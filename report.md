Розміри "fat" i "slim" образів

```commandline
ml_ops_hw % docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
slim         latest    8d690d3828dc   15 minutes ago   1.13GB
fat          latest    4549d8cb342a   3 hours ago      2.8GB
```

Кількість шарів "fat" образу
```commandline
 ml_ops_hw % docker history fat
IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
4549d8cb342a   3 hours ago     ENTRYPOINT ["python" "inference.py"]            0B        buildkit.dockerfile.v0
<missing>      3 hours ago     RUN /bin/sh -c pip install --no-cache-dir -r…   919MB     buildkit.dockerfile.v0
<missing>      3 hours ago     COPY example.jpg . # buildkit                   90.1kB    buildkit.dockerfile.v0
<missing>      3 hours ago     COPY requirements.txt . # buildkit              8.19kB    buildkit.dockerfile.v0
<missing>      3 hours ago     COPY model.pt . # buildkit                      14.5MB    buildkit.dockerfile.v0
<missing>      3 hours ago     COPY inference.py . # buildkit                  8.19kB    buildkit.dockerfile.v0
<missing>      23 hours ago    RUN /bin/sh -c apt-get update && apt-get ins…   21.2MB    buildkit.dockerfile.v0
<missing>      2 weeks ago     CMD ["python3"]                                 0B        buildkit.dockerfile.v0
<missing>      2 weeks ago     RUN /bin/sh -c set -eux;  for src in idle3 p…   16.4kB    buildkit.dockerfile.v0
<missing>      2 weeks ago     RUN /bin/sh -c set -eux;   wget -O python.ta…   59.3MB    buildkit.dockerfile.v0
<missing>      2 weeks ago     ENV PYTHON_SHA256=00e07d7c0f2f0cc002432d1ee8…   0B        buildkit.dockerfile.v0
<missing>      2 weeks ago     ENV PYTHON_VERSION=3.9.25                       0B        buildkit.dockerfile.v0
<missing>      2 weeks ago     ENV GPG_KEY=E3FF2839C048B25C084DEBE9B26995E3…   0B        buildkit.dockerfile.v0
<missing>      2 weeks ago     RUN /bin/sh -c set -eux;  apt-get update;  a…   19.9MB    buildkit.dockerfile.v0
<missing>      2 weeks ago     ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      2 weeks ago     ENV PATH=/usr/local/bin:/usr/local/sbin:/usr…   0B        buildkit.dockerfile.v0
<missing>      21 months ago   RUN /bin/sh -c set -ex;  apt-get update;  ap…   694MB     buildkit.dockerfile.v0
<missing>      21 months ago   RUN /bin/sh -c set -eux;  apt-get update;  a…   202MB     buildkit.dockerfile.v0
<missing>      21 months ago   RUN /bin/sh -c set -eux;  apt-get update;  a…   64.9MB    buildkit.dockerfile.v0
<missing>      21 months ago   # debian.sh --arch 'amd64' out/ 'trixie' '@1…   134MB     debuerreotype 0.16
```

Кількість шарів "slim" образу
```commandline
ml_ops_hw % docker history slim
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
8d690d3828dc   14 minutes ago   ENTRYPOINT ["python" "inference.py"]            0B        buildkit.dockerfile.v0
<missing>      14 minutes ago   COPY inference.py model.pt example.jpg ./ # …   14.6MB    buildkit.dockerfile.v0
<missing>      14 minutes ago   COPY /python-deps /usr/local/lib/python3.12/…   728MB     buildkit.dockerfile.v0
<missing>      2 days ago       CMD ["python3"]                                 0B        buildkit.dockerfile.v0
<missing>      2 days ago       RUN /bin/sh -c set -eux;  for src in idle3 p…   16.4kB    buildkit.dockerfile.v0
<missing>      2 days ago       RUN /bin/sh -c set -eux;   savedAptMark="$(a…   41.3MB    buildkit.dockerfile.v0
<missing>      2 days ago       ENV PYTHON_SHA256=fb85a13414b028c49ba18bbd52…   0B        buildkit.dockerfile.v0
<missing>      2 days ago       ENV PYTHON_VERSION=3.12.12                      0B        buildkit.dockerfile.v0
<missing>      2 days ago       ENV GPG_KEY=7169605F62C751356D054A26A821E680…   0B        buildkit.dockerfile.v0
<missing>      2 days ago       RUN /bin/sh -c set -eux;  apt-get update;  a…   4.94MB    buildkit.dockerfile.v0
<missing>      2 days ago       ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      2 days ago       ENV PATH=/usr/local/bin:/usr/local/sbin:/usr…   0B        buildkit.dockerfile.v0
<missing>      3 days ago       # debian.sh --arch 'amd64' out/ 'trixie' '@1…   87.4MB    debuerreotype 0.16
```

Проблеми "fat" образу
1. Відсутність build context optimization. Це означає, що кожна зміна будь-якого файлу інвалідовує layer, через що Docker буде збирати все з нуля — навіть pip install.
2. Відсутність cleanup після apt-get. Це збільшує розмір образу. Треба видаляти кеш
3. Python 3.9 вже застарілий і EOL вже скоро. Крім того деякі бібліотеки ML можуть його вже не підтримувати.
4. Немає slim-версії Python. `python:3.9` це повний Debian образ і він великий.
5. І т.д.

Оптимізація
Хоча, як ми бачимо, "slim" образ вже має менший розмір і меншу кількість шарів, ніж "fat", у нас ще є простір для оптимізації.
1. Можна використати образ distroless, ультраслим образ з розміром 6–10 МБ, але:
- немає shell
- немає package manager
- немає debug tools
2. При встановленні python залежностей можна додати --no-compile та --no-warn-script-location. Це прибирає .pyc і __pycache__ → мінус 10–30%.
3. Також можна прибрати .dist-info, якщо пакети не вимагатимуть метадані, 99% випадків ок і мінус 20–50 МБ. 
4. Можна запаковувати python застосунок у zipapp i запускати Python в optimized mode
```commandline
python -m zipapp app -o app.pyz -m "inference:main"
```
```dockerfile
CMD ["python", "app.pyz"]
```
5. Модель можна не зберігати у контейнері а завантажувати на старті.
6. Можна також зробити компресію фінального образу з buildx, щоб пришвидшити pull/push образу
```commandline
docker buildx build \
  --output=type=docker,compression=gzip,compression-level=9 \
  -t myimage:latest .
```