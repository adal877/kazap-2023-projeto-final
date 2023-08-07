# Kazap Academy 2023
## Projeto **Final**

### O que houve durante o processo?
Bom. Vamos lá...
  Durante o desenvolvimento quase que aconteceu de tudo: fiquei sem internet, meu ssd parou de funcionar, o lid/"tampa"  
do notebook quebrou... fora outros acontecidos...  
  Com todos os percausos dei continuidade com o projeto lendo a documentação pelo smartphone e fazendo pesquisas em fóruns.  
No final o desenvolvimento acabou por não ser simples mas foi interessante. Interessante em termos de estudo de uma linguagem  
que eu recém aprendi, interessante em termos de análise das lógicas de negócio necessárias e principalmente em termos  
de aprendizagem de criar uma aplicação com sequel e sqlite para utilização via **terminal**.

  Infelizmente não consegui terminar a tempo para implementar a **atualização de contas** e outras regras necessárias, mas fico feliz  
de entregar o projeto e de ter me mente tudo o que aprendi durante o desenvolvimento.

  Agradeço muito à equipe da Kazap pelos ensinamentos e atenção durante o kazap-academy. Com certeza darei continuidade aos estudos  
com ruby e me aprofundarei em outras tecnologias :)

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
  ![Código fonte + models](https://dbdiagram.io/d/64c53bae02bd1c4a5ee83b7c)

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

<details>
<summary>Ações</summary>

### Clientes
#### O sistema deve permitir o cadastro de novos clientes:
1. Armazenar dados como nome, documento (CPF/CNPJ), endereço e telefone;
2. Adicionar validação dos dados.

### Contas
#### Permitir a criação, edição e exclusão de contas:
1. Cada conta deve ter um número único;
2. Um Cliente pode ter várias contas, mas a conta pertence apenas à um Cliente;
3. O saldo inicial da conta deve ser definido como zero.

### Depósitos
#### Ação que irá adicionar fundos à uma determinada conta:
1. O valor do depósito deve ser somado ao saldo atual da conta.

### Saques
#### Ação para remover fundos de uma determinada conta:
1. O valor do saque deve ser subtraído do saldo atual da conta.
2. Caso o saldo atual não seja suficiente, o sistema deve informar a situação e solicitar
uma confirmação do uso do limite do cheque especial.

### Cheque Especial
#### Por padrão, todas as contas terão 100 reais de limite para o cheque especial, não deve
#### ser possível ter um saldo menor que -100;
1. No próximo depósito realizado na conta com saldo negativo devido ao cheque
especial, o valor depositado deve ser usado primeiramente para cobrir o saldo
negativo antes de ser adicionado ao saldo disponível.

### Consulta de Saldo
#### Opção para exibir o saldo disponível de uma determinada conta.

### Transferências
#### Permitir a realização de transferências de uma conta para outra:
1. O valor transferido deve ser subtraído da conta de origem e adicionado ao saldo da
conta de destino;
2. Caso o saldo atual da conta de origem for insuficiente, o sistema não deve realizar a
transação e informar o motivo;
3. Tipo de transferências e taxas:
3.1 TED: Para transferências nessa modalidade será cobrado uma taxa de 1% do valor
transferido;
3.1.a Não será cobrado taxa quando as duas contas forem de mesma
titularidade**.**
3.2 PIX: Nessa modalidade não será cobrado taxa.

### Extrato de Transações
#### Fornecer um extrato com as últimas transações realizadas em uma conta específica;
1. Deve incluir informações como data, tipo de transação:
1.1 Depósito;
1.2 Saque;
1.3 Transferências PIX ou TED:
1.3.a Origem e destion
2. Além de exibir em tela, o sistema deve suportar exportação para arquivos CSV ou
JSON:
2.1 Lembre-se de gerar cada arquivo com identificador único (Timestamp, uuid).
</details>

<details>
<summary>Tratamento de erros</summary>

O sistema deve lidar de forma adequada com possíveis erros, como tentativas de
saque ou transferência com valores inválidos, contas inexistentes, entre outros.
Mensagens de erro claras e informativas devem ser fornecidas ao operador em caso
de problemas.

</details>

<details>
<summary>Interface de Usuário UI</summary>

O sistema deve oferecer uma interface de usuário básica para que o operador possa
interagir com as funcionalidades de forma mais amigável. A UI pode ser simples,
baseada em linha de comando ou utilizando alguma gem para tornar a interface mais
amigável, por exemplo, rainbow.

</details>

<details>
<summary>Documentação</summary>

O projeto deve estar documentado, incluindo instruções claras sobre como executar o
sistema, detalhes sobre a estrutura do banco de dados, diagrama e como utilizar as
funcionalidades.

1. Utilize o arquivo README.md
</details>

<details>
<summary>Desafios</summary>
Adicione a lógica de taxa de juros acumulados diariamente para o cheque especial:

- Taxa de juros diária: 0,23%
- Quando uma operação for realizada e o saldo for insuficiente, o sistema irá informar
a situação e solicitar a confirmação do uso do limite, adicione a informação sobre a
taxa de juros diária que será aplicada diariamente ao saldo devedor;
- No próximo depósito, o cliente deverá depositar um valor para cobrir o saldo
devedor e a taxa de juros acumulada;
- Adicione as informações de saldo devedor e taxa de juros acumulada até o
momento, na funcionalidade de consulta de saldo;
</details>

<details>
<summary>Automações e outros...</summary>

## Ambiente
<details>
<summary>Gerando migrations</summary>

##### Para facilitar a criação dos arquivos de migration eu criei um script em bash
```bash
#!/bin/env bash

gen_migration() {
	for i in ${@}; do
		local mig_code="$(date +%s)"
		local file_name="${mig_code}_create_${i}.rb"
		touch "${file_name}" && echo "${file_name}: DONE" || echo "${file_name}: FAILED"
		sleep 1
	done
}
```
#### Utilização:
```bash
# Array com os nomes dos arquivos/models
migrations=("accounts" "clients" "telephones" "clients_telephones" "transactions" "addresses" "transaction_types" "banks")

# Chamando a função
gen_migration $migrations
```
</details>
</details>

<details>
<summary>Como executar o projeto?</summary>

Instale as dependências
```bash
$ bundle install
```
Em caso de erro com o sequel, instale-o diretamente utilizando ```gem```
```bash
$ gem install sequel
```

Depois de instalado todas as dependências, execute o comando a baixo para gerar o banco de dados
```bash
$ sequel -m migrations sqlite://db/bank.db
```

Agora é só executarmos :D
```bash
$ ruby app.rb
```
</details>
