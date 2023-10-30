public_domain = "default.com" # default domain
region        = "us-east-1"
short_region  = "us1" # short tag for region
instance = {
#  example = {
#    size_volume   = "100",
#    name          = "example", # so your result will be example.default.com
#    instance_type = "t3.medium",
#    env           = "Prod"
#    state         = "running" or "stopped"
#  },
}
mysql = {
#  example = {
#    name    = "example"
#    storage = "20"
#    instance_type = "db.t3.small"
#    param_group = ""
#  }
}
users =  {} # but in the future u can add users as follows: ["itbot", "any.guy"]
iam_group     = {
#  admin = {
#    name       = "admin"
#    policy_arn = ["arn:aws:iam::aws:policy/AdministratorAccess"]
#  }
#  dev = {
#    name       = "dev"
#    policy_arn = [""arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonElastiCacheReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess",
#    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
#    ]
#  }
}
s3_bucket     = {
#  example = {
#    name = "example-bucket"
#  }
}
