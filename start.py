import os

# Masaüstü yolunu al
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
file_name = "mom'sreturntaxes.txt"
file_path = os.path.join(desktop_path, file_name)

try:
    os.remove(file_path)
    print(f"Dosya başarıyla silindi: {file_path}")
except FileNotFoundError:
    print(f"Dosya bulunamadı: {file_path}")
except PermissionError:
    print(f"Dosyayı silmek için izin yok: {file_path}")
except Exception as e:
    print(f"Bilinmeyen bi sıkıntı çıktı: {e}")
