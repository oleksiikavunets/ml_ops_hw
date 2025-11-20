import torch
from torchvision import transforms
from PIL import Image
import sys

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model = torch.jit.load("model.pt", map_location=device)
model.eval()

preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])


def predict(image_path):
    try:
        image = Image.open(image_path).convert("RGB")
    except Exception as e:
        print(f"Error loading image '{image_path}': {e}")
        return

    input_tensor = preprocess(image).unsqueeze(0).to(device)

    with torch.no_grad():
        output = model(input_tensor)
        probabilities = torch.nn.functional.softmax(output[0], dim=0)

        top3_prob, top3_catid = torch.topk(probabilities, 3)

    for prob, cat in zip(top3_prob, top3_catid):
        print(f"Class: {cat.item()} | Confidence: {prob.item():.4f}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python inference.py <image_path>")
        sys.exit(1)

    predict(sys.argv[1])
