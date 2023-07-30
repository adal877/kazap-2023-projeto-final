# Kazap Academy 2023
## Projeto **Final**


# Projeto
### Proposta
```
Desenvolver um sistema de banco em Ruby que será capaz de cadastrar clientes,
contas, realizar transferências entre as contas e gerar um histórico das transações.
```

### Requisitos
```
O repositório deverá estar no GitHub e link deve ser enviado via formulário até a data
limite: 06/08 às 23h59
```
### Regra de Negócios
#### Modelagem
##### shamelessly exported from dbdiagram.io :)
```sql
CREATE TABLE `clients` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `timestamp` DateTime NOT NULL,
  `first_name` string NOT NULL,
  `last_name` string NOT NULL,
  `document` string NOT NULL
);

CREATE TABLE `accounts` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `client_id` integer NOT NULL AUTO_INCREMENT,
  `bank_id` integer NOT NULL,
  `address_id` integer NOT NULL,
  `timestamp` DateTime NOT NULL,
  `account_number` integer NOT NULL,
  `initial_balance` integer NOT NULL
);

CREATE TABLE `banks` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `address_id` integer UNIQUE NOT NULL,
  `timestamp` DateTime NOT NULL,
  `name` string NOT NULL,
  `code` integer NOT NULL
);

CREATE TABLE `addresses` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `timestamp` DateTime NOT NULL,
  `street` string NOT NULL,
  `city` string NOT NULL,
  `number` integer NOT NULL,
  `state` string NOT NULL,
  `state_abbreviation` string NOT NULL
);

CREATE TABLE `telephones` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `timestamp` DateTime NOT NULL,
  `number` integer NOT NULL,
  `code_area` integer NOT NULL,
  `is_cellphone` boolean DEFAULT true
);

CREATE TABLE `client_telephones` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `client_id` integer NOT NULL,
  `telephone_id` integer NOT NULL
);

CREATE TABLE `transactions` (
  `id` integer PRIMARY KEY,
  `from_account_id` integer NOT NULL,
  `to_account_id` integer NOT NULL,
  `timestamp` DateTime
);

CREATE TABLE `transaction_type` (
  `id` integer UNIQUE PRIMARY KEY NOT NULL,
  `transaction_id` integer,
  `name` string NOT NULL,
  `code` string NOT NULL DEFAULT "P" COMMENT '[P]ix, [T]ed, [W]ithdral, [D]ebit'
);

ALTER TABLE `accounts` ADD FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`);

ALTER TABLE `accounts` ADD FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`);

ALTER TABLE `accounts` ADD FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);

ALTER TABLE `addresses` ADD FOREIGN KEY (`id`) REFERENCES `banks` (`address_id`);

ALTER TABLE `client_telephones` ADD FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`);

ALTER TABLE `client_telephones` ADD FOREIGN KEY (`telephone_id`) REFERENCES `telephones` (`id`);

ALTER TABLE `transactions` ADD FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `transactions` ADD FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `transaction_type` ADD FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`);

```
