# 4. Requisitos do Projeto 

**4.1 Requisitos Funcionais**

| ID  | Nomeclatura | Descrição |
| ----|----|----| 
|RF01 | Registrar ponto | Permitir que os funcionários registrem suas entradas e saídas utilizando o horário padrão atual do GMT-3. | 
|RF02  |  Cálculo de horas | Calcular automaticamente as horas, horas extras e atrasos de cada funcionário e disponibilizar os cálculos parciais e finais. | 
|RF03  |  Enviar lembretes de ponto | Permitir que os administradores enviem lembretes aos funcionários caso haja esquecimento na marcação. | 
|RF04  |  Notificar aula VIP | Notificar os superiores sempre que um professor realizar uma aula do tipo VIP. | 
|RF05  |  Gerar relatórios mensais | Gerar relatórios mensais de ponto dos funcionários, com os cálculos de horas, atrasos, e horas extras, podendo esses serem exportados em PDF. | 
|RF06  |  Assinatura digital | Permitir que os funcionários assinem digitalmente os relatórios de ponto ao final de cada mês, sem a necessidade de impressão. | 
|RF07   |  Acessar e controlar os registros de ponto em tempo real |  Permitir que os gestores acessem e monitorem em tempo real os registros de ponto de todos os funcionários. | 
|RF08  |  Cadastrar funcionário | Permitir o cadastro de novos funcionários, com seus respectivos emails institucionais e senha de no mínimo 6 caracteres. | 
|RF09  | Definição de horário de expediente | Registrar carga horária específica de trabalho dos funcionários, definidas por semestre.  | 
| RF10 | Login | O sistema deve apresentar uma tela inicial de autenticação de usuário que peça o email e a senha cadastrados.|
|RF11 | Notificar funcionário | O sistema deve permitir que a coordenação envie mensagens diretas e personalizadas aos funcionários, com a possibilidade de incluir avisos, instruções ou informações importantes.|
|RF12 | Controle de Faltas| O sistema deve permitir que sejam registradas faltas. |
|RF13 | Acompanhamento de Férias e Licenças| O sistema deve possibilitar o acompanhamento de férias, licenças e outros períodos de afastamento dos funcionários.|

**4.2 Requisitos não Funcionais**

| ID  | Nomeclatura | Descrição |
| ----|----|----| 
|RNF01 | Usabilidade| A interface deve apresentar no máximo 6 ícones ou botões por página, a fim de evitar sobrecarga visual e promover uma experiência de usuário fluida. |
|RNF02 | Desempenho| O sistema deve ser capaz de processar os registros de ponto dos funcionários em um fluxo de até 500 reg/s com um tempo de resposta inferior a 1 segundo para cada ação.|
|RNF03 | Suportabilidade| O sistema deve ser compatível com dispositivos móveis que operem em sistemas Android e iOS, tendo como base principal o estilo PWA (Progressive Web App).|
|RNF04 | Escalabilidade| O sistema deve ser projetado para suportar um aumento no número de funcionários e na carga de dados sem comprometer o desempenho ou a confiabilidade.|
|RNF05 | Implementação| O sistema deve ser desenvolvido utilizando tecnologias Flutter para o Front-end e Django/Python para o Back-end, além de PostgreSQL para o banco de dados, garantindo uma integração fluida entre as partes do sistema.|
|RNF06 | Segurança| O sistema deve garantir a confiabilidade no armazenamento das informações, ou seja, efetuar backups regulares para evitar perdas em caso de desastre.|
|RNF07 | Reusabilidade| Componentes de software responsáveis por executar funções específicas, como cálculos de horas trabalhadas ou controle de intervalos, devem ser projetados de forma modular, permitindo sua reutilização em diferentes partes do sistema de marcação de ponto.|
|RNF08 | Confiabilidade| O sistema deve garantir a segurança dos dados dos funcionários, protegendo informações sensíveis, como as senhas de acesso.|
