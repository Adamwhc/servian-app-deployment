# use aws s3 for remote state
terraform {
    backend "s3" {
        bucket = "tf-remote-state-app"
        key    = "app-tf-state.tf"
        region = "ap-southeast-2"
    }
}
