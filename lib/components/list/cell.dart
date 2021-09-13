//
// cell.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/foundation/hotkeys.dart';
import 'package:pluck/providers/link/model.dart';
import 'package:pluck/providers/link/provider.dart';
import 'package:pluck/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCell extends StatefulWidget {
  final Link link;

  ListCell({
    Key? key,
    required this.link
  });

  @override
  State<ListCell> createState() => _ListCellState();
}

class _ListCellState extends State<ListCell> {

  Widget _imageView() {
    return Image.network(
      widget.link.url,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _content() {
    return Container(
      child: widget.link.type == "image"
      ? _imageView()
      : Text("Not image"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: MacosDynamicColor.resolve(MacosColors.alternatingContentBackgroundColor, context),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _content()),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: 
                Text(
                  'plk.io/${widget.link.tag}/${widget.link.code}',
                  style: TextStyle(
                    color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(140),
                    fontSize: 12
                  ),
                )
              ),
              AppIconButton(
                backgroundColor: Colors.transparent,
                size: 32,
                icon: Icon(
                  FluentIcons.clipboard_arrow_right_16_regular,
                  color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(140),
                ), 
                onPressed: () async {
                  final url = Api.shortUrl(widget.link);

                  Hotkeys.copyShortcut(url);
                }
              ),
              AppIconButton(
                backgroundColor: Colors.transparent,
                size: 32,
                icon: Icon(
                  FluentIcons.open_16_filled,
                  color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(140),
                ), 
                onPressed: () async {
                  final url = Api.shortUrl(widget.link);

                  if(await canLaunch(url)) {
                    await launch(url);
                  }
                }
              ),
            ],
          )
        ],
      ),
    );
  }
}