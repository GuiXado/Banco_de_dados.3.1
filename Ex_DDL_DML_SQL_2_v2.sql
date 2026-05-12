CREATE DATABASE locadora
GO

USE locadora
GO

CREATE TABLE filme (
id		INT		NOT NULL,
titulo		VARCHAR(40)	NOT NULL,
ano		INT		NULL 		CHECK(ano <= 2021),

PRIMARY KEY(id)
)
GO

CREATE TABLE estrela (
id		INT		NOT NULL,
nome		VARCHAR(50)	NOT NULL,

PRIMARY KEY(id)
)
GO

CREATE TABLE filme_estrela (
filmeid		INT		NOT NULL,
estrelaid	INT		NOT NULL,

PRIMARY KEY(filmeid, estrelaid),

FOREIGN KEY(filmeid) REFERENCES filme(id),
FOREIGN KEY(estrelaid) REFERENCES estrela(id)
)
GO

CREATE TABLE dvd (
num			INT		NOT NULL,
data_fabricacao		DATE		NOT NULL	CHECK(data_fabricacao < GETDATE()),
filmeid			INT		NOT NULL,

PRIMARY KEY(num),

FOREIGN KEY(filmeid) REFERENCES filme(id)
)
GO

CREATE TABLE cliente (
num_cadastro	INT		NOT NULL,
nome		VARCHAR(70)	NOT NULL,
logradouro	VARCHAR(150)	NOT NULL,
num		INT		NOT NULL	CHECK(num > 0), 
cep		CHAR(8)		NULL		CHECK(LEN(cep) = 8),

PRIMARY KEY(num_cadastro)
)
GO

CREATE TABLE locacao (
dvdnum			INT		NOT NULL,
clientenum_cadastro	INT		NOT NULL,
data_locacao		DATE		NOT NULL	DEFAULT(GETDATE()),
data_devolucao		DATE		NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0),

PRIMARY KEY(dvdnum, clientenum_cadastro, data_locacao),

FOREIGN KEY(dvdnum) REFERENCES dvd(num),
FOREIGN KEY(clientenum_cadastro) REFERENCES cliente(num_cadastro),

CONSTRAINT chk_data
CHECK(data_devolucao > data_locacao)
)
GO

--ADD coluna de "nome_real"
ALTER TABLE estrela
ADD nome_real VARCHAR(50) NULL
GO

--Modificar titulo para VARCHAR(80)
ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL
GO

--INSERT Filme
INSERT INTO filme VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)
GO

--INSERT Estrela
INSERT INTO estrela VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')
GO

--Inserindo Filme_Estrela
INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)
GO

--INSERT DVD
INSERT INTO dvd VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)
GO

--INSERT Cliente
INSERT INTO cliente VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
GO

--INSERT Locação
INSERT INTO locacao VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)
GO

--Atualizar CEPs
UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503
GO

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504
GO

--Atualizar valor locação cliente 5502
UPDATE locacao
SET valor = 3.25
WHERE clientenum_cadastro = 5502
AND data_locacao = '2021-02-18'
GO

--Atualizar valor locação cliente 5501
UPDATE locacao
SET valor = 3.10
WHERE clientenum_cadastro = 5501
AND data_locacao = '2021-02-24'
GO

--Atualizar fabricação DVD
UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE num = 10005
GO

--Atualizar nome real
UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'
GO

--Excluir filme Sing
DELETE FROM filme
WHERE titulo = 'Sing'
GO


-- CONSULTAS

--1
SELECT titulo
FROM filme
WHERE ano = 2014
GO

--2
SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'
GO

--3
SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'
GO

--4
SELECT id, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'
GO

--5
SELECT filmeid, CONVERT(CHAR(10), data_fabricacao, 103) AS fab
FROM dvd
WHERE data_fabricacao >= '2020-01-01'
GO

--6
SELECT dvdnum, data_locacao, data_devolucao, valor, valor + 2.00 AS valor_com_multa
FROM locacao
WHERE clientenum_cadastro = 5505
GO

--7
SELECT logradouro, num, cep
FROM cliente
WHERE nome = 'Matilde Luz'
GO

--8
SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'
GO

--9 -- CAST aqui está  valor numerico da coluna "num" para varchar(10), para conseguir concatenar string
SELECT num_cadastro, nome, logradouro + ', ' + CAST(num AS VARCHAR(10)) + ' - ' + cep AS end_comp
FROM cliente
WHERE num_cadastro >= 5503
GO