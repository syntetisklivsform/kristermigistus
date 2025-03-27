#!/bin/bash

# Uppdatera systemet först
echo "Uppdaterar systemet..."
sudo apt update && sudo apt upgrade -y

# Installera nödvändiga beroenden (Java och andra verktyg)
echo "Installerar beroenden..."
sudo apt install -y openjdk-11-jre curl

# Ladda ner Arduino IDE 2 (senaste versionen för Linux 64-bit AppImage)
echo "Laddar ner Arduino IDE 2..."
cd ~/Downloads
wget -O arduino-ide.AppImage https://downloads.arduino.cc/arduino-ide/arduino-ide_latest_Linux_64bit.AppImage

# Gör AppImage-filen körbar
chmod +x arduino-ide.AppImage

# Flytta den till /opt för att göra den mer permanent
sudo mv arduino-ide.AppImage /opt/arduino-ide.AppImage

# Lägg till användaren i dialout-gruppen för att få åtkomst till seriella portar (för Arduino Uno)
echo "Lägger till din användare i dialout-gruppen..."
sudo usermod -a -G dialout $USER

# Skapa en skrivbordsgenväg för Arduino IDE
echo "Skapar en skrivbordsgenväg..."
cat << EOF > ~/.local/share/applications/arduino-ide.desktop
[Desktop Entry]
Name=Arduino IDE
Exec=/opt/arduino-ide.AppImage
Type=Application
Icon=arduino
Terminal=false
Categories=Development;
EOF

# Gör genvägen körbar
chmod +x ~/.local/share/applications/arduino-ide.desktop

# Installera Arduino Uno-drivrutiner (oftast redan inkluderade i moderna Linux-kärnor, men vi säkerställer)
echo "Säkerställer att Arduino Uno fungerar..."
sudo apt install -y arduino-core

# Skapa ett enkelt Blink-exempel för att testa
echo "Skapar ett enkelt Blink-exempel..."
mkdir -p ~/Arduino/Blink
cat << EOF > ~/Arduino/Blink/Blink.ino
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}
EOF

# Informera användaren om nästa steg
echo "Installationen är klar!"
echo "1. Starta Arduino IDE från menyn (under 'Development' eller sök efter 'Arduino IDE')."
echo "2. Anslut din Arduino Uno via USB."
echo "3. Öppna filen '~/Arduino/Blink/Blink.ino' i Arduino IDE."
echo "4. Välj 'Arduino Uno' under Tools > Board och rätt port under Tools > Port."
echo "5. Klicka på 'Upload' för att testa Blink-programmet!"
echo "OBS: Du kan behöva logga ut och in igen för att gruppen 'dialout' ska aktiveras."
