# Module Cloud Nat Gateway

This module does the following configuration:

- generates static public ip's
- generates cloud router with nat enabled in a specific region

## Example Usage

```terraform
module "nat" {
  source = "../nat_gateway"

  project_id    = "project-id"
  vpc_name      = "my-vpc"
  vpc_self_link = "https://www.googleapis.com/compute/v1/projects/project-id/global/networks/my-vpc"

  nat_num_addresses    = 3
  region               = us-east4
  subnetwork_self_link = "https://www.googleapis.com/compute/v1/projects/project-id/global/networks/my-vpc/subnet/my-subnet"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.11 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.7.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.7.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.nat_external_addresses](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_router.nat_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.compute_nat_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nat_num_addresses"></a> [nat\_num\_addresses](#input\_nat\_num\_addresses) | number of NAT external IP's to reserve | `number` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID for Restricted Shared VPC. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region for cloud nat | `string` | n/a | yes |
| <a name="input_subnetwork_self_link"></a> [subnetwork\_self\_link](#input\_subnetwork\_self\_link) | subnetwork self link | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | name of vpc | `string` | n/a | yes |
| <a name="input_vpc_self_link"></a> [vpc\_self\_link](#input\_vpc\_self\_link) | vpc network self link | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_router_id"></a> [nat\_router\_id](#output\_nat\_router\_id) | an identifier for the resource with format {{project}}/{{region}}/{{router}}/{{name}} |
<!-- END_TF_DOCS -->