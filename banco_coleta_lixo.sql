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


-- Inserindo dados dos usuarios (3 registros)
INSERT INTO usuarios (nome, email, senha_hash, telefone) VALUES
('Ana Silva', 'ana@example.com', 'hash_senha_teste_1', '11987654321'),
('Carlos Mendes', 'carlos@example.com', 'hash_senha_teste_2', '11988887777'),
('Fernanda Rocha', 'fernanda@example.com', 'hash_senha_teste_3', NULL);

-- inserindo dados das solicitações (3 registros)
INSERT INTO solicitacoes (id_usuario, nome, endereco, tipo_lixo, status)
VALUES
(1, 'Ana Silva', 'Rua das Palmeiras, 101', 'Celular', 'Aguardando'),
(2, 'Carlos Mendes', 'Av. Brasil, 2000', 'Notebook', 'Recebida'),
(3, 'Fernanda Rocha', 'Rua Nova, 55', 'TV', 'Cancelamento Solicitado');

-- Inserindo os tipos status (3 registros)
INSERT INTO logs_status (id_solicitacao, status_anterior, status_novo, motivo)
VALUES
(1, 'Aguardando', 'Recebida', 'Coletor registrou recebimento'),
(2, 'Recebida', 'Cancelamento Solicitado', 'Usuário solicitou cancelamento'),
(3, 'Aguardando', 'Cancelado', 'Cancelamento automático pelo sistema');

-- Inserindo as insformações retornadas na integração (3 registros)
INSERT INTO integracoes_prefeitura (
    id_solicitacao, recebido_em, status_prefeitura, protocolo_prefeitura, mensagem_retorno
)
VALUES
(1, NOW(), 'Confirmado', 'PRT-2025-001', 'Solicitação recebida com sucesso'),
(2, NOW(), 'Recusado', 'PRT-2025-002', 'Endereço fora da área de cobertura'),
(3, NULL, NULL, NULL, 'Aguardando envio para a prefeitura');
