import base64
import requests
headers = {
    "access-token": "WOW1234563"
}
image = open("leaves.png", "rb").read()
data ={
  "type": "vit_t",
  "bbox": [
    0,
    0,
    0,
    0
  ],
  "point_coords": [
    [
      0,
      0
    ],
    [
      1,
      0
    ]
  ],
  "point_labels": [
    0,
    1
  ],
  "b64img": base64.b64encode(image).decode("utf-8"),
  # "b64mask": "string",
  "multimask_output": "false"

}
response = requests.post("http://localhost:8000/sam", headers=headers, json=data, timeout=200)
if response.status_code == 200:
    try:
        print(response.json())
    except requests.JSONDecodeError:
        print("Response did not contain valid JSON")
else:
    print(f"Error: Received status code {response.status_code}")
