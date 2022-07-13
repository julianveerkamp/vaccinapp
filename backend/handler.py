import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('vaccineTable')


class DecimalEncoder(json.JSONEncoder):
  def default(self, obj):
    if isinstance(obj, Decimal):
      return str(obj)
    return json.JSONEncoder.default(self, obj)


def update(event, context):
    scanRes = table.scan()
    items = scanRes['Items']

    body = {
        "items": items
    }

    response = {"statusCode": 200, "body": json.dumps(body, cls=DecimalEncoder)}

    return response


def recommend(event, context):
    parameters = event['pathParameters']
    country = parameters['country']

    if country != "all":
        filter_expr = (Attr('countries').contains(country) | Attr('countries').not_exists())
        scanRes = table.scan(FilterExpression=filter_expr)
    else: 
        scanRes = table.scan()
        
    recommendations = scanRes['Items']

    body = {
        "recommendations": recommendations
    }

    response = {"statusCode": 200, "body": json.dumps(body, cls=DecimalEncoder)}
    return response



def seed(event, context):
    data = """[{
  "name": "COVID-19",
  "targetID": "840539006",
  "type": "human",
  "vaccines": [
    {
      "id": "EU/1/20/1528",
      "name": "COMIRNATY",
      "manufacturer": "Biontech AG"
    },
    {
      "id": "EU/1/20/1507",
      "name": "Spikevax",
      "manufacturer": "Moderna"
    }
  ],
  "age": 3
},
{
  "name": "Rabies",
  "targetID": "000000001",
  "type": "human",
  "vaccines": [
    {
      "id": "EU/0/15/0001",
      "name": "Rabipur",
      "manufacturer": "ACME Inc."
    }
  ],
  "age": 12,
  "countries": ["thailand"]
},
{
  "name": "Hepatites A",
  "targetID": "000000003",
  "type": "human",
  "vaccines": [
    {
      "id": "EU/0/15/0002",
      "name": "Avaxim",
      "manufacturer": "ACME Inc."
    },
    {
      "id": "EU/0/15/0003",
      "name": "Havrix",
      "manufacturer": "ACME Inc."
    },
    {
      "id": "EU/0/15/0004",
      "name": "VAQTA",
      "manufacturer": "ACME Inc."
    },
    {
      "id": "EU/0/15/0005",
      "name": "Viatim",
      "manufacturer": "ACME Inc."
    },
    {
      "id": "EU/0/15/0006",
      "name": "Twinrix",
      "manufacturer": "ACME Inc."
    }
  ],
  "age": 12,
  "countries": ["greece", "thailand"]
},
{
  "name": "Cat Flu",
  "targetID": "100000001",
  "type": "cat",
  "vaccines": [
    {
      "id": "EMEA/V/C/000090",
      "name": "Purevax RCP",
      "manufacturer": "Boehringer Ingelheim Vetmedica GmbH"
    }
  ]
},
{
  "name": "Rabies",
  "targetID": "200000001",
  "type": "dog",
  "vaccines": [
    {
      "id": "EMEA/V/C/005090",
      "name": "Purevax RCP",
      "manufacturer": "Intervet International B.V."
    }
  ]
}]"""

    items = json.loads(data)

    for item in items:
        print(item)
        table.put_item(Item=item)

    response = {"statusCode": 200, "body": "success"}

    return response