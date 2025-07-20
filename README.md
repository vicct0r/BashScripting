# Bash Scripting Repository

## 📝 Descrição
Repositório contendo coleção de scripts Bash automatizados para administração de sistemas, deploy de aplicações e automação de tarefas. 

**Ambiente seguro para testes:**
- Todos os scripts foram desenvolvidos e testados em ambientes isolados usando **Vagrant (VM)**
- Prontos para execução sem riscos à sua máquina física
- Compatível com sistemas Linux/Unix

## 🛠️ Pré-requisitos
- Vagrant ([Instalação](https://www.vagrantup.com/downloads))
- VirtualBox ou outro provider compatível
- Git (para clonar o repositório)

## 🚀 Modo de Uso

### 1. Configuração do Ambiente
- Crie o Vagrant Box:  
  `vagrant init <box_name>`
- Rode a instância:  
  `vagrant up`
- Acesse a VM:  
  `vagrant ssh`

### 2. Execução do Script
- Dentro da VM, crie/copie o arquivo:  
  `vim <nome_arquivo>.sh`
- Conceda permissões:  
  `sudo chmod +x <nome_arquivo>.sh`
- Execute:  
  `./<nome_arquivo>.sh`

### Considerações Importantes
- Para executar os comandos **vagrant** você deve estar no diretório do **Vagrantfile**.
- Só **deve existir um Vagrantfile** no diretório.
- Scripts marcados como "CentOS9" precisarão de adaptações para Ubuntu/Jammy64.
- Verifique as notas em cada diretório para requisitos específicos.
- O **Vagrant** precisa de um Hypervisor para funcionar. Mas você não deve ter mais de um gerênciando as VMs pois isso gera erro de hierarquia entre os Hypervisors.
