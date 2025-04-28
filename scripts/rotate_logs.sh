#!/bin/bash

# Configuration
LOG_DIR="logs"
MAX_LOG_FILES=5
MAX_LOG_SIZE=10485760  # 10MB

# Fonction pour compresser et archiver les anciens logs
rotate_logs() {
    local log_file=$1
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Compresser le fichier de log actuel
    if [ -f "$LOG_DIR/$log_file" ]; then
        gzip -c "$LOG_DIR/$log_file" > "$LOG_DIR/${log_file}.${timestamp}.gz"
        > "$LOG_DIR/$log_file"  # Vider le fichier original
    fi
    
    # Supprimer les anciens fichiers compressés
    ls -t "$LOG_DIR/${log_file}.*.gz" | tail -n +$((MAX_LOG_FILES + 1)) | xargs rm -f
}

# Vérifier la taille des logs et les faire tourner si nécessaire
for log_file in $(ls $LOG_DIR/*.log $LOG_DIR/*.txt 2>/dev/null); do
    if [ -f "$log_file" ]; then
        size=$(stat -c%s "$log_file")
        if [ $size -gt $MAX_LOG_SIZE ]; then
            rotate_logs $(basename "$log_file")
        fi
    fi
done 