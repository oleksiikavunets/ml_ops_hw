
# Image Classification Inference

Цей проєкт дозволяє виконувати інференс моделі глибинного навчання (TorchScript `.pt` модель) для класифікації зображень.  
Модель завантажується з `model.pt`, застосовує стандартну ImageNet-підготовку та повертає **top-3 класи**.

README містить інструкції для запуску:

- 💻 у локальному середовищі (Linux)  
- 🐳 у Docker-контейнері  

---

# 📦 Installation (Linux)

Для інсталяції всіх необхідних залежностей у локальному середовищі Linux використовуйте скрипт:

```bash
./install_dev_tools.sh
````

Скрипт автоматично:

* перевіряє наявність та встановлює `docker`, `docker compose`, `python3`, `pip`
* встановлює Python-пакети (torch, torchvision, pillow)
* записує всю інформацію у `install.log`

> !!! Скрипт призначений **для Linux**. 

---

# Run Locally

Щоб виконати інференс на локальній машині:

```bash
python3 inference.py example.jpg
```

Параметри:

* Перший аргумент — шлях до зображення
* У відповідь виводиться топ-3 класи (ID)

Приклад:

```bash
python3 inference.py ./images/dog.jpg
```

---

# Run in Docker

Ви можете виконувати інференс у повністю ізольованому Docker-середовищі, використовуючи оптимізований `Dockerfile.slim`.

---

## Build Docker image

```bash
docker build -f Dockerfile.slim -t slim .
```

Пояснення:

* `-f Dockerfile.slim` — використовувати slim-версію Dockerfile
* `-t slim` — створити локальний образ з тегом `slim`

Перевірити:

```bash
docker images | grep slim
slim         latest    8d690d3828dc   26 minutes ago   1.13GB
```

---

## Run inference inside Docker

```bash
docker run -it slim example.jpg
```

Оскільки під час зборки Dockerfile копіює `example.jpg` у контейнер, цей файл доступний одразу після запуску.

---

# Passing your own image to Docker (optional)

Для запуску інференсу над зовнішнім зображенням:

```bash
docker run -it -v $(pwd):/app slim /app/my_image.jpg
```

Це:

* монтує ваш поточний каталог у контейнер (`$(pwd) → /app`)
* передає шлях до файлу `/app/my_image.jpg`
* запускає інференс по ньому

---

# Example output

```
220
123
445
```

Це ID топ-3 класів для зображення.

---

# Files Overview

```
inference.py         — головний скрипт інференсу
model.pt             — TorchScript модель
example.jpg          — тестове зображення
requirements.txt     — Python-залежності
Dockerfile.slim      — оптимізований Dockerfile з multi-stage build
install_dev_tools.sh — автоматичний інсталятор залежностей
```
