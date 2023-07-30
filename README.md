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

![Modelagem](https://github.com/adal877/kazap-2023-projeto-final/blob/dev/documents/images/projeto_final_modelagem.jpeg)
<details>
  <summary>Código em DBML</summary>

  ```sql
  Table clients {
    id integer [primary key, increment, not null, unique]
    timestamp DateTime [not null]
    first_name string [not null]
    last_name string [not null]
    document string [not null]
  }

  Table accounts {
    id integer [primary key, increment, not null, unique]
    client_id integer [ref: > clients.id, increment, not null]
    bank_id integer [ref: > banks.id, not null]
    address_id integer [ref: > addresses.id, not null]
    timestamp DateTime [not null]
    account_number integer [not null]
    initial_balance integer [not null]
  }

  Table banks {
    id integer [primary key, increment, not null, unique]
    address_id integer [ref: < addresses.id, unique, not null]
    timestamp DateTime [not null]
    name string [not null]
    code integer [not null]
  }

  Table addresses {
    id integer [primary key, increment, not null, unique]
    timestamp DateTime [not null]
    street string [not null]
    city string [not null]
    number integer [not null]
    state string [not null]
    state_abbreviation string [not null]
  }

  Table telephones {
    id integer [primary key, increment, not null, unique]
    timestamp DateTime [not null]
    number integer [not null]
    code_area integer [not null]
    is_cellphone boolean [default: true]
  }

  Table client_telephones {
    id integer [primary key, increment, not null, unique]
    client_id integer [ref: > clients.id, not null]
    telephone_id integer [ref: > telephones.id, not null]
  }

  Table transactions {
    id integer [primary key]
    from_account_id integer [ref: > accounts.id, not null]
    to_account_id integer [ref: > accounts.id, not null]
    timestamp DateTime
  }

  Table transaction_type {
    id integer [primary key, not null, unique]
    transaction_id integer [ref: > transactions.id]
    name string [not null]
    code string [default: "P", not null, note: "[P]ix, [T]ed, [W]ithdral, [D]ebit"]
  }
  ```
</details>
