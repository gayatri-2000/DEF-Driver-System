class DeliveryInstructionResponseModel {
  String? status;
  int? instructionCount;
  List<DeliveryInstruction>? instructions;
  String? message;

  DeliveryInstructionResponseModel({
    this.status,
    this.instructionCount,
    this.instructions,
    this.message,
  });

  DeliveryInstructionResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    instructionCount = json['instruction_count'];
    if (json['instructions'] != null) {
      instructions = <DeliveryInstruction>[];
      json['instructions'].forEach((v) {
        instructions!.add(DeliveryInstruction.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['instruction_count'] = instructionCount;
    if (instructions != null) {
      data['instructions'] = instructions!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class DeliveryInstruction {
  int? instructionId;
  String? instruction;
  String? instructionType;
  String? createdBy;
  String? createdDate;

  DeliveryInstruction({
    this.instructionId,
    this.instruction,
    this.instructionType,
    this.createdBy,
    this.createdDate,
  });

  DeliveryInstruction.fromJson(Map<String, dynamic> json) {
    instructionId = json['instruction_id'];
    instruction = json['instruction'];
    instructionType = json['instruction_type'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instruction_id'] = instructionId;
    data['instruction'] = instruction;
    data['instruction_type'] = instructionType;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    return data;
  }
}
