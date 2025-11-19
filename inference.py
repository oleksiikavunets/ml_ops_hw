import torch
from torchvision import transforms
from PIL import Image
import sys

model = torch.jit.load("model.pt")
model.eval()

preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor()
])

def predict(image_path):
    image = Image.open(image_path).convert("RGB")
    input_tensor = preprocess(image).unsqueeze(0)

    with torch.no_grad():
        output = model(input_tensor)
        probabilities = torch.nn.functional.softmax(output[0], dim=0)

        *_, top3_catid = torch.topk(probabilities, 3)

        [print(catid.item()) for catid in top3_catid]

if __name__ == "__main__":
    predict(sys.argv[1])
