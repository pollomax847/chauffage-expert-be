#!/bin/bash

# Configuration
LOG_FILE="load_test.log"
MAX_USERS=100
RAMP_UP_TIME=60
DURATION=300
RECOVERY_THRESHOLD=5
ERROR_THRESHOLD=10

# Fonction de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# Fonction de test de charge
run_load_test() {
    log "Démarrage du test de charge..."
    
    # Simulation d'utilisateurs simultanés
    for ((users=1; users<=MAX_USERS; users++)); do
        log "Test avec $users utilisateurs simultanés"
        
        # Mesure des performances
        start_time=$(date +%s)
        error_count=0
        request_count=0
        
        # Simulation des requêtes
        for ((i=1; i<=users; i++)); do
            # Test des différentes fonctionnalités
            endpoints=(
                "calcul/chauffage"
                "calcul/hydraulique"
                "calcul/vmc"
                "pdf/generation"
            )
            
            for endpoint in "${endpoints[@]}"; do
                response=$(curl -s -w "%{http_code}" -o /dev/null "https://$DOMAIN/api/$endpoint")
                request_count=$((request_count + 1))
                
                if [ "$response" != "200" ] && [ "$response" != "304" ]; then
                    error_count=$((error_count + 1))
                    log "Erreur sur $endpoint: $response"
                fi
            done
        done
        
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        requests_per_second=$((request_count / duration))
        
        log "Résultats pour $users utilisateurs:"
        log "- Requêtes/s: $requests_per_second"
        log "- Erreurs: $error_count"
        log "- Durée: ${duration}s"
        
        # Vérification des seuils
        if [ $error_count -gt $ERROR_THRESHOLD ]; then
            log "ALERTE: Trop d'erreurs détectées"
            trigger_recovery
            break
        fi
        
        # Attente progressive
        sleep $((RAMP_UP_TIME / MAX_USERS))
    done
}

# Fonction de récupération automatique
trigger_recovery() {
    log "Déclenchement de la récupération automatique..."
    
    # 1. Sauvegarde de l'état actuel
    log "Sauvegarde de l'état actuel..."
    ./scripts/monitor.sh create_backup
    
    # 2. Vérification des ressources
    log "Vérification des ressources..."
    check_resources
    
    # 3. Redémarrage des services
    log "Redémarrage des services..."
    restart_services
    
    # 4. Vérification de la récupération
    log "Vérification de la récupération..."
    verify_recovery
}

# Fonction de vérification des ressources
check_resources() {
    # Vérification de la mémoire
    memory_usage=$(free -m | awk '/Mem:/ {print $3/$2 * 100.0}')
    if (( $(echo "$memory_usage > 90" | bc -l) )); then
        log "ALERTE: Utilisation mémoire élevée: ${memory_usage}%"
        # Libérer de la mémoire en redémarrant les services
        restart_services
    fi

    # Vérification de l'espace disque
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    if [ "$disk_usage" -gt 85 ]; then
        log "ALERTE: Espace disque faible: ${disk_usage}%"
        # Nettoyage des fichiers temporaires
        clean_temp_files
    fi

    # Vérification du CPU
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}') # User + System CPU
    if (( $(echo "$cpu_usage > 90" | bc -l) )); then
        log "ALERTE: Utilisation CPU élevée: ${cpu_usage}%"
        log "Optimisation du CPU..."
        # Ajouter des actions spécifiques ici (ex: identifier et killer les processus gourmands)
        # pkill -f "processus_gourmand"
    fi
}

# Fonction de redémarrage des services
restart_services() {
    # TODO: Envisager un redémarrage plus ciblé si possible,
    # en fonction du type de problème détecté.
    # Redémarrage du serveur web
    log "Redémarrage du serveur web..."
    systemctl restart nginx
    
    # Redémarrage des services d'application
    log "Redémarrage des services d'application..."
    pm2 restart all
    
    # Attente de la stabilisation
    sleep 30
}

# Fonction de vérification de la récupération
verify_recovery() {
    attempts=0
    while [ $attempts -lt $RECOVERY_THRESHOLD ]; do
        if ./scripts/monitor.sh test_deployment; then
            log "Récupération réussie !"
            return 0
        fi
        attempts=$((attempts + 1))
        sleep 10
    done
    
    log "Échec de la récupération après $attempts tentatives"
    return 1
}

# Fonction principale
main() {
    log "Démarrage des tests de charge..."
    run_load_test
    log "Tests de charge terminés"
}

# Exécution
main