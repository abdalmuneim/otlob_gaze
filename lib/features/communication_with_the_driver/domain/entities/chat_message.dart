class ChatMessage {
  int? userId;
  String? message;
  int? messageStatus;
  DateTime? date;
  String? type;
  String? id;

  ChatMessage({
    this.userId,
    this.message,
    this.date,
    this.messageStatus,
    this.type,
    this.id,
  });

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.message == message &&
        other.id == id &&
        other.messageStatus == messageStatus &&
        other.type == type &&
        other.date == date;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        message.hashCode ^
        id.hashCode ^
        type.hashCode ^
        messageStatus.hashCode ^
        date.hashCode;
  }

  ChatMessage copyWith({
    int? userId,
    String? id,
    String? message,
    int? messageStatus,
    DateTime? date,
    String? type,
  }) {
    return ChatMessage(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      message: message ?? this.message,
      messageStatus: messageStatus ?? this.messageStatus,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}
