CREATE DATABASE `wk`;
use wk;

-- Tabela de Clientes
CREATE TABLE clientes (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    uf CHAR(2)
);

-- Tabela de Produtos
CREATE TABLE produtos (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10, 2) NOT NULL
);

-- Tabela de Pedidos (Dados Gerais)
CREATE TABLE pedidos (
    numero_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

-- Tabela de Produtos do Pedido
CREATE TABLE pedidos_produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_pedido INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
    FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Inserção de Clientes
INSERT INTO clientes (nome, cidade, uf) VALUES
('Cliente 1', 'São Paulo', 'SP'),
('Cliente 2', 'Rio de Janeiro', 'RJ'),
('Cliente 3', 'Belo Horizonte', 'MG'),
('Cliente 4', 'Curitiba', 'PR'),
('Cliente 5', 'Florianópolis', 'SC'),
('Cliente 6', 'Porto Alegre', 'RS'),
('Cliente 7', 'Brasília', 'DF'),
('Cliente 8', 'Salvador', 'BA'),
('Cliente 9', 'Fortaleza', 'CE'),
('Cliente 10', 'Recife', 'PE'),
('Cliente 11', 'Manaus', 'AM'),
('Cliente 12', 'Belém', 'PA'),
('Cliente 13', 'Goiânia', 'GO'),
('Cliente 14', 'Campinas', 'SP'),
('Cliente 15', 'São Luís', 'MA'),
('Cliente 16', 'Maceió', 'AL'),
('Cliente 17', 'Aracaju', 'SE'),
('Cliente 18', 'João Pessoa', 'PB'),
('Cliente 19', 'Natal', 'RN'),
('Cliente 20', 'Vitória', 'ES'),
('Cliente 21', 'Cuiabá', 'MT'),
('Cliente 22', 'Campo Grande', 'MS'),
('Cliente 23', 'São José', 'SC'),
('Cliente 24', 'Londrina', 'PR'),
('Cliente 25', 'Ribeirão Preto', 'SP'),
('Cliente 26', 'Uberlândia', 'MG'),
('Cliente 27', 'Juiz de Fora', 'MG'),
('Cliente 28', 'Sorocaba', 'SP'),
('Cliente 29', 'Bauru', 'SP'),
('Cliente 30', 'Volta Redonda', 'RJ');

-- Inserção de Produtos
INSERT INTO produtos (descricao, preco_venda) VALUES
('Produto A', 10.50),
('Produto B', 25.00),
('Produto C', 15.75),
('Produto D', 5.00),
('Produto E', 30.00),
('Produto F', 50.25),
('Produto G', 8.90),
('Produto H', 12.50),
('Produto I', 45.00),
('Produto J', 20.00),
('Produto K', 60.00),
('Produto L', 18.75),
('Produto M', 9.90),
('Produto N', 11.25),
('Produto O', 55.00),
('Produto P', 6.50),
('Produto Q', 35.75),
('Produto R', 4.95),
('Produto S', 22.80),
('Produto T', 28.00),
('Produto U', 14.30),
('Produto V', 7.60),
('Produto W', 31.25),
('Produto X', 19.40),
('Produto Y', 13.85),
('Produto Z', 49.90),
('Produto AA', 40.00),
('Produto BB', 17.25),
('Produto CC', 26.00),
('Produto DD', 33.50);