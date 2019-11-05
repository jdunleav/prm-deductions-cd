resource "aws_instance" "buildmonitor" {
    ami                             = "ami-00a1270ce1e007c27"
    instance_type                   = "t2.micro"
    vpc_security_group_ids          = ["${aws_security_group.buildmonitor-sg.id}"]
    subnet_id                       = "${module.vpc.private_subnets[0]}"
    key_name                        = "deductions-buildmonitor"
    iam_instance_profile            = "${aws_iam_instance_profile.buildmonitor-profile.name}"

    user_data = "${file("templates/user_data.sh")}"
    
    tags = {
        Name = "${var.environment}-${var.component_name}-buildmonitor"
    }
}

