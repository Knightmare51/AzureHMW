variable "default_tags" {
  type = map(string)
  default = {
    "env" = "eyeri"
  }
  description = "description for eyeri variable"
}