CREATE TABLE Cliente (
    codigo_cliente integer PRIMARY KEY,
    nome_cliente varchar (20),
    cpf integer
);

CREATE TABLE Pedido (
    codigo_ped integer PRIMARY KEY,
    dt_pedido date,
    total_compra float,
    fk_Cliente_codigo_cliente integer
);

CREATE TABLE Produto (
    codigo_prod integer PRIMARY KEY,
    nome_produto varchar (100),
    preco_unit float
);

CREATE TABLE Contem (
    fk_Produto_codigo_prod integer,
    fk_Pedido_codigo_ped integer
);
 
ALTER TABLE Pedido ADD CONSTRAINT FK_Pedido_2
    FOREIGN KEY (fk_Cliente_codigo_cliente)
    REFERENCES Cliente (codigo_cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Contem ADD CONSTRAINT FK_Contem_1
    FOREIGN KEY (fk_Produto_codigo_prod)
    REFERENCES Produto (codigo_prod)
    ON DELETE RESTRICT;
 
ALTER TABLE Contem ADD CONSTRAINT FK_Contem_2
    FOREIGN KEY (fk_Pedido_codigo_ped)
    REFERENCES Pedido (codigo_ped)
    ON DELETE SET NULL;