output "nat_router_id" {
  description = "an identifier for the resource with format {{project}}/{{region}}/{{router}}/{{name}}"
  value       = google_compute_router_nat.compute_nat_router.id
}