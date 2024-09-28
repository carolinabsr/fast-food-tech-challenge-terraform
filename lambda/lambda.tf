resource "aws_lambda_function" "auth_function" {
  function_name = "auth_function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "lambda_auth.zip"
  publish       = true

  environment {
    variables = {
      DB_HOST     = module.database.instance_address
      DB_NAME     = module.database.db_name
      DB_USER     = module.database.db_username
      DB_PASSWORD = module.database.db_password
      JWT_SECRET  = var.jwt_secret
    }
  }

  vpc_config {
    subnet_ids         = aws_db_subnet_group.main.subnet_ids
    security_group_ids = aws_security_group.lambda_sg.id
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_execution]
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Action : "sts:AssumeRole",
      Effect : "Allow",
      Principal : {
        Service : "lambda.amazonaws.com"
      }
    }]
  })
}

output "auth_function_arn" {
  value = aws_lambda_function.auth_function.arn
}

output "auth_function_invoke_arn" {
  value = aws_lambda_function.auth_function.invoke_arn
}

output "auth_function_name" {
  value = aws_lambda_function.auth_function.function_name
}
