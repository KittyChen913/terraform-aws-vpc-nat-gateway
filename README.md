# Terraform AWS VPC & NAT Gateway

一個用於創建 AWS VPC 和 NAT Gateway 的 Terraform 專案。

## 架構圖
![Architecture](docs/terraform-aws-ec2-example.drawio.png)

本專案設計了一個典型的 AWS 網路架構：

- **Public Subnet** - 包含可直接訪問網際網路的資源
  - Public EC2 Instance 可從外部直接通過 SSH 連接
  - 流量通過 Internet Gateway 進出
  
- **Private Subnet** - 包含不需要直接網際網路訪問的資源
  - Private EC2 Instance 只能透過 Bastion (Public Instance) 連接
  - 出站網際網路流量通過 NAT Gateway 進行 (對外隱藏真實 IP)
  - 無法從外部直接連接

## 環境需求

- 安裝 [Terraform](https://www.terraform.io/)
- 配置 [AWS CLI Profile](https://docs.aws.amazon.com/zh_tw/cli/v1/userguide/cli-configure-files.html#cli-configure-files-format-profile)

## SSH Key 配置

這個專案會建立 EC2 實例，需要 SSH Key 來進行連線測試。

如果還沒有 SSH Key，請執行以下命令生成：
```bash
ssh-keygen -t ed25519 -f ~/.ssh/terraform-ec2
```

這會產生兩個檔案：
- `~/.ssh/terraform-ec2` - 私鑰（保管好，不要分享）
- `~/.ssh/terraform-ec2.pub` - 公鑰（Terraform 會上傳到 AWS）

公鑰會被上傳到 AWS 作為 Key Pair，讓你可以用私鑰 SSH 連線到 EC2 實例進行測試。

## 快速開始

1. **複製範例配置文件**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **客製化你的配置**
   ```bash
   vim terraform.tfvars
   ```

3. **初始化並部署**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **測試連線**
   
   部署完成後會 output 以下連線字串，可直接複製使用：
   <br>
   
   連接 Public EC2：
   ```bash
   ssh -i ~/.ssh/terraform-ec2 ec2-user@<public_ec2_ip>
   ```
   
   連接 Private EC2（透過 Bastion）：
   ```bash
   ssh -o "ProxyCommand=ssh -i ~/.ssh/terraform-ec2 -W %h:%p ec2-user@<public-ip>" -i ~/.ssh/terraform-ec2 ec2-user@<private-ip>
   ```

5. **使用完畢，清理資源**
   ```bash
   terraform destroy
   ```

## 項目結構

```text
.
├── .gitignore                 # Git 忽略文件配置
├── .terraform.lock.hcl        # Terraform 鎖定 provider 版本的檔案
├── docs/                      # 專案文件目錄 (包含架構圖)
├── providers.tf               # Terraform 配置和 Data Sources
├── network.tf                 # VPC、Subnet、Internet Gateway、NAT Gateway、Route Table
├── security.tf                # Key Pair、Security Group
├── compute.tf                 # EC2 Instance
├── outputs.tf                 # Output 定義
├── variables.tf               # 變數定義
├── terraform.tfvars.example   # 變數值範例文件
├── README.md                  # 專案說明文件
└── terraform.tfstate*         # Terraform 狀態文件 (不會提交到 Git)
```

## 資源說明

### 網路層
- **VPC** - 自定義虛擬私有雲
- **Public Subnet** - 位於第一個可用區 (10.0.0.0/20)
- **Private Subnet** - 位於第二個可用區 (10.0.16.0/20)
- **Internet Gateway** - 提供 Public Subnet 連接到網際網路
- **NAT Gateway** - 提供 Private Instance 連接到網際網路 (使用 Elastic IP)
- **Route Table** - 分別為 Public 和 Private Subnet 設定路由規則

### 安全層
- **Key Pair** - 上傳本地 SSH public key 到 AWS
- **Security Group** - 設定防火牆規則，允許 SSH 連接

### 計算層
- **Public EC2 Instance** - 可直接從外部連接 (10.0.0.0/20 subnet)
- **Private EC2 Instance** - 只能透過 Public Instance (Bastion) 連接，但可透過 NAT Gateway 訪問網際網路

## 注意事項

- `terraform.tfstate` 包含敏感信息，已加入 `.gitignore`，不會提交到版本控制
- 確保 AWS CLI profile 正確配置（此範例使用 `admin` profile）
- public key 路徑使用 `~/.ssh/terraform-ec2.pub`，請確保該檔案存在

