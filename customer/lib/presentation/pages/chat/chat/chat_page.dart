// ignore_for_file: unused_result

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dingtea/application/chat/chat_provider.dart';
import 'package:dingtea/infrastructure/models/data/chat_message_data.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/enums.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/chat_item.dart';

@RoutePage()
class ChatPage extends ConsumerStatefulWidget {
  final String roleId;
  final String name;

  const ChatPage({
    super.key,
    required this.roleId,
    required this.name,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.refresh(chatProvider);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(chatProvider.notifier).fetchChats(context, widget.roleId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppStyle.bgGrey,
          leading: IconButton(
            splashRadius: 18.r,
            onPressed: context.maybePop,
            icon: Icon(
              isLtr
                  ? FlutterRemix.arrow_left_s_line
                  : FlutterRemix.arrow_right_s_line,
              size: 24.r,
              color: AppStyle.black,
            ),
          ),
          title: Text(
            widget.name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: AppStyle.black,
              letterSpacing: -0.4,
            ),
          ),
        ),
        body: Consumer(builder: (context, ref, child) {
          final state = ref.watch(chatProvider);
          final notifier = ref.read(chatProvider.notifier);
          return state.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.r,
                    color: AppStyle.primary,
                  ),
                )
              : Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _fireStore
                          .collection('messages')
                          .where('chat_id', isEqualTo: state.chatId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.r,
                              color: AppStyle.primary,
                            ),
                          );
                        }
                        final List<DocumentSnapshot> docs = snapshot.data!.docs;
                        final List<ChatMessageData> messages = docs.map(
                          (doc) {
                            final Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;

                            if (data['unread'] && data['sender'] == 0) {
                              _fireStore
                                  .collection('messages')
                                  .doc(doc.id)
                                  .update({'unread': false});
                            }
                            final Timestamp t = data['created_at'];
                            final DateTime date = t.toDate();
                            return ChatMessageData(
                              messageOwner: data['sender'] == 0
                                  ? MessageOwner.partner
                                  : MessageOwner.you,
                              message: data['chat_content'],
                              time: '${date.hour}:${date.minute}',
                              date: date,
                            );
                          },
                        ).toList();
                        messages.sort((a, b) => b.date.compareTo(a.date));
                        return ListView.builder(
                          itemCount: messages.length,
                          reverse: true,
                          controller: scrollController,
                          padding: REdgeInsets.only(
                            bottom: 87,
                            top: 20,
                            left: 15,
                            right: 15,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final chatData = messages[index];
                            return ChatItem(chatData: chatData);
                          },
                        );
                      },
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        color: AppStyle.bgGrey,
                        child: Container(
                          height: 64.r,
                          margin: REdgeInsets.all(24),
                          padding: REdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppStyle.black),
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppStyle.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: state.textController,
                                  cursorWidth: 1.r,
                                  cursorColor: AppStyle.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.k2d(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      letterSpacing: -0.5,
                                      color: AppStyle.black,
                                    ),
                                    hintText: AppHelpers.getTranslation(
                                      TrKeys.typeSomething,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: notifier.sendMessage,
                                child: Container(
                                  width: 37,
                                  height: 37,
                                  decoration: BoxDecoration(
                                    color: AppStyle.black,
                                    borderRadius: BorderRadius.circular(37),
                                  ),
                                  child: Icon(
                                    FlutterRemix.send_plane_2_line,
                                    size: 18.r,
                                    color: AppStyle.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
        }),
      ),
    );
  }
}
// 42424242424242424242
// String@sdf.dsf
// 04/44
