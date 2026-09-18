import boto3, json, os
from flask import Flask, request, jsonify

app = Flask(__name__)
SQS_QUEUE_URL = os.environ.get('SQS_QUEUE_URL', '')
sqs_client = boto3.client('sqs', region_name='us-east-1')

@app.route('/produtos', methods=['GET'])
def listar_produtos():
    return jsonify([
        {"id": 1, "nome": "Teclado Mecanico", "preco": 350.00},
        {"id": 2, "nome": "Monitor IPS 24", "preco": 800.00}
    ])

@app.route('/pedidos', methods=['POST'])
def criar_pedido():
    dados = request.get_json(force=True, silent=True) or {}
    mensagem = {
        "pedido_id": dados.get("id", 101),
        "produto": dados.get("produto", "Teclado"),
        "status": "pendente"
    }
    response = sqs_client.send_message(
        QueueUrl=SQS_QUEUE_URL,
        MessageBody=json.dumps(mensagem)
    )
    return jsonify({"status": "pedido enviado", "message_id": response.get('MessageId')})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
