# HandyAWSManager
Easy and Convenient way to create ec2 with route 53. And other AWS services.

This project is easy to reuse if you need a simple infrastructure from EC2 instances. The main reason why this project appeared:
I was looking for a way to create several different EC2 servers in the configuration. But the only option that
the community offers me is the use of modules. But if you need to create 5 different servers with different names/instance type/disk size.
Then you need to create the same module several times with different configurations, which will take up much more space in the code than my solution.

## Description

With this project, you can launch new ec2 instances, create s3 buckets and start users.
Since you can use multiple AWS accounts, the following implementation for reuse was invented
TF(terraform) code. The 'terraform workspace` and various variables to them help with this.
That is, 1 workspace is 1 tfvars file.
The new server will be created with Ubuntu OS and will be ready to work with Ansible, since there will be a public_key on the server, and all changes
are made via ssh.
Also here you can manage Security Groups, if necessary.

### CI/CD

In .ci/Terraform.gitlab-ci.yml, a template is described in which code validation, Terraform initialization, and terraform plan are performed,
terraform apply. Actually, Gitlab artifacts, caches necessary for Terraform work, which
must be kept secret, are transferred between these jobs.

Working with the template allows you to conveniently create a CI/CD Job for each AWS account using this example:

```
tf plan for <AWS account ID>:
  extends:
    - .terraform:tf_plan
  variables:
    AWS_ACCOUNT: <AWS account ID>
    AWS_ACCESS_KEY_ID: $<Masked CI/CD variable AWS ACCESS KEY>
    AWS_SECRET_KEY: $<Masked CI/CD variable AWS SECRET KEY>
  only:
    changes:
      - Terraform/vars/<AWS account ID>.tfvars
```
Due to this, when changing variables for one of the AWS accounts, a workspace with the name <AWS account ID> will be created/used,
after which the `terraform plan` will be launched for this particular AWS account, with the necessary AWSCredentials.

#### !!! There are limitations when creating and using multiple workspace (see below)!!!

Check the result of the `terraform plan`, be careful and keep track of which resources are being created/changed/deleted.
Example of the `terraform plan` result:

```
Plan: 1 to add, 0 to change, 0 to destroy. 
# No resources will be deleted or changed - safe to execute terraform apply
```

### How Terraform works?
For infrastructure management in Terraform, we will use *.tfvars files.

#### Editing/creating a file Terraform/vars/*.tfvars.
    There are 3 main variables that may differ for different AWS accounts:

1) For example, `public_domain = "default.com"`. Indicates the public domain that will be used for future
   ec2 servers and their DNS records.
2) Also, different AWS accounts may have different default avsregion. So you set `region = "us-east-1"`.
3) And for the convenience of tagging AWS resources and filtering them in Cost Explorer, you need a tag, and consequently a variable:
   `short_region  = "us1"`

#### Description of the new server

After the above variables, you may notice the variable `instance = {}`, in which we will describe
our future servers.

To create a new server, you must specify its name. This name will be used in the AWS UI in the EC2 instances tab,
and will also be used to create a DNS record. For example, the domain test.${var.public_domain}. e.g will be created with the name "test". test.default.com
For each server, a section is created with the server name inside which there are the following parameters size_volume, name, instance_type, env, state.

The `name` parameter specifies the name of the server, as well as the DNS record. The parameter is specified as string: `name = "test",`

The size of the server disk is specified by the parameter `size_volume = 200`. Type: string.

The next required parameter is `instance_type`. The EC2 instance type is specified here:

```
instance_type = "t3.medium",`
```
The following parameter is used to tag the resources being created.
   ```
   env = "Prod"
   ```

There are tasks on different projects where it is necessary to stop the server for a while. As a result, the parameter appeared:
`state = "running"` or you can use value "stopped".

Example:

```
  instance = {
    test = {
    size_volume   = "100",
    name          = "us-east-1-test",
    instance_type = "r5.xlarge",
    env           = "Dev"
    state         = "running"
    },
}
```
#### Description of mysql server

By analogy with ec2 instance, you can create MySQL RDS, but before that, pay attention to the variable in CI/CD `mysql_pass`
Example:
```
mysql = {
  example = {
    name    = "example"
    storage = "20"
    instance_type = "db.t3.small"
    param_group = "your_param_group"
  }
}
```

#### Management of IAM Users, IAM Groups, S3 bucket
All this can also be created in a simple way using the following example:
```
users = ["itbot", "any.guy"]
iam_group     = {
  admin = {
    name       = "admin"
    policy_arn = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
  dev = {
    name       = "dev"
    policy_arn = [""arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonElastiCacheReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    ]
  }
}
s3_bucket     = {
  example = {
    name = "example-bucket"
  }
}
```
After the commit, the pipeline will start, which will first plan the creation of the server/resources. After that, you need to manually run job tf_apply.

### Restrictions

For example, you cannot apply multiple changes on different accounts at once. This limitation is due to the only
job tf_apply.

### Adding a new AWS account

On a new AWS account, you need to create a user, for example, itbot, with admin rights. Create a CI/CD variable
with AWSCredentials.

# HandyAWSManager. RU Descriptions
Easy and Convenient way to create ec2 with route 53. And other AWS services.

Этот проект легок для re-use если вам необходима простая инфраструктура из EC2 instances. Главная причина по которой появился этот проект:
Я искал способ создать несколько, при этом разных в конфигурации EC2 серверов. Но единственный вариант, который предлагает мне
сообщество - это использование модулей. Но если вам необходимо создать 5 разных серверов с разными именами/instance type/disk size.
То вам необходимо несколько раз создать один и тот же модуль с разным конфигурациями, что займет намного больше места в коде, чем мое решение.

## Description

С помощью этого проекта можно запускать новые ec2 instances, создавать s3 buckets и заводить пользователей.
Так как вы можете использовать несколько AWS аккаунтов, была придумана следующая реализация для re-use
TF(terraform) кода. С этим помогает `terraform workspace` и разные переменные к ним.
То есть 1 workspace - 1 tfvars файл.
Новый сервер будет создан с ОС Ubuntu и будет готов к работе с Ansible, так как на сервере будет public_key, а все изменения
вносятся по ssh.
Также здесь вы можете управлять Security Groups, если это необходимо.

### CI/CD

В .ci/Terraform.gitlab-ci.yml Описан шаблон, в котором выполняется проверка кода, инициализация Terraform, terraform plan,
terraform apply. Собственно между этими job'ами передаются Gitlab artifacts, caches необходимые для работы Terraform, которые
необходимо хранить секретно.

Работа с шаблоном позволяет удобно создать CI/CD Job для каждого AWS аккаунта по этому примеру:
```
tf plan for <AWS account ID>:
  extends:
    - .terraform:tf_plan
  variables:
    AWS_ACCOUNT: <AWS account ID>
    AWS_ACCESS_KEY_ID: $<Masked CI/CD variable AWS ACCESS KEY>
    AWS_SECRET_KEY: $<Masked CI/CD variable AWS SECRET KEY>
  only:
    changes:
      - Terraform/vars/<AWS account ID>.tfvars
```

Благодаря чему, при изменении переменных для одного из AWS аккаунтов, создастся/используется workspace с именем <AWS account ID>,
после чего запустится `terraform plan` именно для этого AWS аккаунта, с необходимыми AWS credentials.

#### !!! There are limitations when creating and using multiple workspace (see below)!!!

Проверьте результат `terraform plan`, будьте аккуратны и следите за тем, какие ресурсы создаются/меняются/удаляются.
Пример результата `terraform plan`:
```
Plan: 1 to add, 0 to change, 0 to destroy. 
# Никакие ресурсы не будут удалены или изменены - безопасно к выполнению terraform apply
```

### How Terraform works?
Для менеджмента инфраструктуры в Terraform мы будем использовать файлы *.tfvars.

#### Editing/creating a file Terraform/vars/*.tfvars.
    Есть 3 главных переменных которые могут отличаться для разных AWS аккаунтов:

1) Например, `public_domain = "default.com"`. Указывает на публичный domain который будет использоваться для будущих
   ec2 серверов и их DNS-записей.
2) Также в разных AWS аккаунтах может быть разные default aws region. Так вы устанавливаете `region = "us-east-1"`.
3) И для удобства тегирования AWS resources и фильтрования их в Cost Explorer нужен tag, а следствие и переменная:
   `short_region  = "us1"`

#### Description of the new server

После выше перечисленных переменных вы можете заметить переменную `instance = {}`, в которой как раз мы и будем описывать
наши будущие сервера.

Для создания нового сервера необходимо указать его имя. Это имя будет использоваться в ui AWS во вкладке EC2 instances,
а также использоваться для создания DNS-записи. Например, с name "test" будет создан домен test.${var.public_domain}. e.g. test.default.com
Для каждого сервера создается секция с именем сервера внутри которой есть следующие параметры size_volume, name, instance_type, env, state.

Параметр `name` задает имя серверу, а также DNS запись. Параметр указывается как string: `name = "test",`

Размер диска сервера указывается параметром `size_volume = 200`. Type: string.

Следующий обязательный параметр - "instance_type". Тут указывается тип EC2 instance:
```
instance_type = "t3.medium",`
```
Следующий параметр используется для тегирования создаваемых ресурсов.
   ```
   env = "Prod"
   ```

На разных проектах есть задачи где необходимо останавливать сервер на время. Вследствие чего появился параметр:
`state = "running"` или же можно использовать value "stopped".

Example:

```
  instance = {
    test = {
    size_volume   = "100",
    name          = "us-east-1-test",
    instance_type = "r5.xlarge",
    env           = "Dev"
    state         = "running"
    },
}
```
#### Описание mysql сервера

По аналогии с ec2 instance, вы можете создать RDS MySQL, но перед этим обратите внимание на переменную в CI/CD `mysql_pass`
Example:
```
mysql = {
  example = {
    name    = "example"
    storage = "20"
    instance_type = "db.t3.small"
    param_group = "your_param_group"
  }
}
```

#### Управление IAM Users, IAM Groups, S3 buckets
Все это также в простом виде можно создать по следующему примеру:
```
users = ["itbot", "any.guy"]
iam_group     = {
  admin = {
    name       = "admin"
    policy_arn = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
  dev = {
    name       = "dev"
    policy_arn = [""arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonElastiCacheReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    ]
  }
}
s3_bucket     = {
  example = {
    name = "example-bucket"
  }
}
```
После commit'а запустится pipeline, который сначала спланирует создание сервера/ресурсов. После чего необходимо вручную запустить job'у tf_apply.

### Ограничения

Например, применить сразу несколько изменений на разных аккаунтах нельзя. Это ограничение обусловлено единственной
job'ой tf_apply.

### Добавление нового AWS аккаунта

На новом AWS аккаунте нужно создать пользователя , например itbot, с admin правами. Создайте CI/CD переменную
с AWS credentials. 
