# Projeto E-commerce AWS - Capacita iRede (IFCE) 🚀

Trabalho final desenvolvido para o **Curso de Computação em Nuvem** do Instituto Federal de Educação, Ciência e Tecnologia do Ceará (IFCE) em parceria com o Capacita iRede.

Este projeto implementa uma arquitetura de e-commerce resiliente e assíncrona na AWS utilizando conceitos de Infraestrutura como Código (IaC) e Computação Serverless.

## 🏗️ Arquitetura do Projeto

O fluxo de dados da aplicação segue o modelo desacoplado:
**Usuário** ➔ **API (Flask rodando em EC2)** ➔ **Fila SQS** ➔ **Função Lambda** ➔ **Logs do CloudWatch**

1. O usuário interage com a API Flask hospedada em uma instância EC2.
2. A rota de pedidos envia as mensagens para uma fila do AWS SQS de forma assíncrona.
3. O SQS engatilha uma função AWS Lambda que processa o pedido.
4. O resultado do processamento é registrado e monitorado através do Amazon CloudWatch Logs.

---

## 📂 Estrutura do Repositório

```text
├── terraform/     # Infraestrutura como Código (VPC, Subnet, IGW, Route Table, SG, EC2, SQS, Lambda, IAM)
├── app/           # Código do servidor web
│   └── app.py     # API Flask com as rotas `/produtos` e `/pedidos`
└── lambda/        # Código serverless
    └── index.py   # Função Lambda disparada automaticamente pelo SQS
```

---

## 🛠️ Pré-requisitos

Antes de começar, você precisará ter instalado em sua máquina:
* **Terraform 1.0+**
* **AWS CLI** configurada localmente com as credenciais ativas do **AWS Academy Learner Lab**.

---

## 🚀 Como Executar

### 1. Implantar a Infraestrutura
Navegue até a pasta do Terraform, inicialize o provedor e aplique as configurações:
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
_Nota: Após a conclusão do deploy, o endereço IP público da sua instância será exibido no terminal através do output `ec2_public_ip`._

### 2. Testar o Fluxo de Pedidos

* **Listar produtos disponíveis (GET):**
  ```bash
  curl http://<IP_EC2>/produtos
  ```

* **Criar um novo pedido (POST - Envia para o SQS):**
  ```bash
  curl -X POST http://<IP_EC2>/pedidos \
       -H "Content-Type: application/json" \
       -d '{"id":1,"produto":"Teclado"}'
  ```

* **Verificar o Processamento:**
  Acesse o Console AWS e verifique os logs gerados no **CloudWatch Logs** sob o grupo: `/aws/lambda/ecommerce-capacita-processor`.

---

## 📸 Evidências de Funcionamento (Entregáveis)

Para validação do projeto, certifique-se de documentar:
- [ ] Print ou log da instância EC2 com a aplicação rodando respondendo ao `curl /produtos`.
- [ ] Print do Console AWS mostrando a mensagem chegando na fila do SQS.
- [ ] Print dos logs da função Lambda executada com sucesso no CloudWatch.

---

## 🛑 Encerramento e Limpeza

Para evitar custos desnecessários e limpar todos os recursos criados no laboratório, execute:
```bash
terraform destroy -auto-approve
```
**(Atenção: Não deixe o `terraform apply` rodando permanentemente após a validação do tutor!)**
