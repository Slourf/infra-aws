output "pipeline" {
    value = aws_codepipeline.pipeline
}

output "toh-frontend" {
    value = aws_ecs_task_definition.toh-frontend
}

output "toh-backend" {
    value = aws_ecs_task_definition.toh-backend
}