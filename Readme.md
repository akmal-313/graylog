# 📄 Graylog + OpenSearch Log Pipeline Simulation

Ce projet met en place un environnement Docker Compose avec 5 conteneurs pour simuler la collecte, le filtrage et la redirection de logs via **Graylog** et **OpenSearch**.

## 📌 Architecture des conteneurs

1. **Graylog**  
   - Interface Web pour la gestion des logs.  
   - Filtrage des logs via **pipelines** et **rules**.
   - Connexion à OpenSearch pour l’indexation.

2. **OpenSearch**  
   - Moteur de recherche et d’indexation pour stocker les logs.

3. **OpenSearch Dashboards**  
   - Interface Web pour visualiser les données dans OpenSearch.

4. **Log Source Simulator**  
   - Envoi de logs au format **GELF JSON** vers Graylog via API.

5. **Rule Generator Simulator**  
   - Génère dynamiquement des règles de filtrage au format JSON.

6. **Log Destination Simulator** *(optionnel)*  
   - Reçoit les logs filtrés depuis Graylog pour valider la sortie.

---

## 🚀 Lancer l’environnement

```bash
docker-compose up -d
