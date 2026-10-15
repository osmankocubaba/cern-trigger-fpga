import numpy as np
import matplotlib.pyplot as plt

# 1. 1000 adet saat darbesi (clock cycle) için sentetik veri
np.random.seed(42)
samples = 1000

# Normal dedektör arka plan gürültüsü (ortalama: 10, standart sapma: 3)
signal = np.random.normal(loc=10, scale=3, size=samples)

# Rastgele anlarda gelen 5 adet yüksek enerjili parçacık çarpışması (pik)
event_indices = [120, 310, 480, 650, 820]
for idx in event_indices:
    signal[idx : idx + 5] += np.array([40, 95, 120, 60, 20])

# Değerleri 16-bit ADC sınırlarına (pozitif tam sayı) dönüştür
signal = np.clip(signal, 0, 65535).astype(int)

# 2. Verilog Testbench'in okuyabilmesi için dosyaya yaz
with open("detector_stream.txt", "w") as f:
    for val in signal:
        f.write(f"{val}\n")

print("Tamamlandı: 'detector_stream.txt' dosyası oluşturuldu.")
