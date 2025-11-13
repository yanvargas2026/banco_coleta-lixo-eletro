-- ==========================================
-- CRIAÇÃO DO BANCO
-- ==========================================
CREATE DATABASE coleta_lixo;
USE coleta_lixo;

-- ==========================================
-- TABELA: usuarios
-- ==========================================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    criado_em TIMESTAMP DEFAULT NOW()
);

-- ==========================================
-- TABELA: solicitacoes
-- ==========================================
CREATE TABLE solicitacoes (
    id_solicitacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    tipo_lixo VARCHAR(80) NOT NULL,
    status ENUM('Aguardando', 'Recebida', 'Cancelado', 'Cancelamento Solicitado') 
        DEFAULT 'Aguardando',
    criado_em TIMESTAMP DEFAULT NOW(),
    atualizado_em TIMESTAMP DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- ==========================================
-- TABELA: logs_status
-- ==========================================
CREATE TABLE logs_status (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitacao INT NOT NULL,
    status_anterior VARCHAR(40) NOT NULL,
    status_novo VARCHAR(40) NOT NULL,
    motivo VARCHAR(255),
    alterado_em TIMESTAMP DEFAULT NOW(),
    
    FOREIGN KEY (id_solicitacao) REFERENCES solicitacoes(id_solicitacao)
);

-- ==========================================
-- TABELA: integracoes_prefeitura
-- ==========================================
CREATE TABLE integracoes_prefeitura (
    id_integracao INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitacao INT NOT NULL,
    enviado_em TIMESTAMP DEFAULT NOW(),
    recebido_em TIMESTAMP NULL,
    status_prefeitura VARCHAR(80),
    protocolo_prefeitura VARCHAR(50),
    mensagem_retorno TEXT,
    
    FOREIGN KEY (id_solicitacao) REFERENCES solicitacoes(id_solicitacao)
);
