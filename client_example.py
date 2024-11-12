import base64
import requests
headers = {
    "access-token": "WOW1234563"
}
image = open("leaves.png", "rb").read()
data = {
    "type": "vit_h",
    "b64img": base64.b64encode(image).decode("utf-8"),
    "points_per_side": 32,
    "points_per_batch": 64,
    "pred_iou_thresh": 0.88,
    "stability_score_thresh": 0.95,
    "stability_score_offset": 1,
    "box_nms_thresh": 0.7,
    "crop_n_layers": 0,
    "crop_nms_thresh": 0.7,
    "crop_overlap_ratio": 0.3413333333333333,
    "crop_n_points_downscale_factor": 1,
    "min_mask_region_area": 0,
    "output_type": "Single Mask",
    "include_image_edge": "false",
    # "checkpoint_url": None
}
response = requests.post("http://localhost:8000/sam/automask", headers=headers, json=data, timeout=130)
if response.status_code == 200:
    try:
        print(response)
    except requests.JSONDecodeError:
        print("Response did not contain valid JSON")
else:
    print(f"Error: Received status code {response.status_code}")
