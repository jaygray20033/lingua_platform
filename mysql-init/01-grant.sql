-- Grant user lingua access from any host (needed when backend runs on host machine)
CREATE USER IF NOT EXISTS 'lingua'@'%' IDENTIFIED BY 'lingua123';
GRANT ALL PRIVILEGES ON lingua_db.* TO 'lingua'@'%';
FLUSH PRIVILEGES;
