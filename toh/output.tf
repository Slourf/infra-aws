output "pipeline" {
    value = aws_codepipeline.devops_pipeline_toh
}

output "toh_frontend" {
    value = aws_ecs_task_definition.toh_frontend
}

output "toh_backend" {
    value = aws_ecs_task_definition.toh_backend
}