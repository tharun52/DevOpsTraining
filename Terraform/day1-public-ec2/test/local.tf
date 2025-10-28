resource "local_file" "test" {
    filename = var.filename
    content = "hi ${pet_name}"
    file_permission = "0700"
}
resource "random_pet" "pet" {
    prefix = "mr"
    separator = "."
    length = 1
}

output "pet_name" {
  value = random_pet.pet.id
}