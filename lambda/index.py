import json

def handler(event, context):
    for record in event.get('Records', []):
        body = json.loads(record['body'])
        print(f"[PROCESSADOR DE PEDIDOS] Pedido recebido com sucesso: {body}")
    return {"statusCode": 200, "body": "Sucesso"}
