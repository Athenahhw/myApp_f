import 'package:flutter/material.dart';

// 1. 程式入口
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, // 去除右上角 debug 標籤
    home: H2Page(),
  ));
}

// 定義一個簡單的筆記資料結構
class Note {
  String title;
  String content;

  Note({required this.title, required this.content});
}

// 2. 主頁面 (顯示筆記列表)
class H2Page extends StatefulWidget {
  const H2Page({super.key});

  @override
  State<H2Page> createState() => _H2PageState();
}

class _H2PageState extends State<H2Page> {
  // 預設的兩個筆記
  List<Note> notes = [
    Note(title: '1234', content: '5678'),
    Note(title: 'abcd', content: 'efgh'),
  ];

  // 刪除筆記的函數
  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  // 跳轉到新增頁面並接收回傳資料
  void _navigateToAddPage() async {
    // 等待 AddNotePage 回傳結果 (result)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );

    // 如果有回傳筆記 (不是直接按返回鍵)，就把它加入列表
    if (result != null && result is Note) {
      setState(() {
        notes.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7), // 淺粉色背景，類似截圖
      appBar: AppBar(
        title: const Text("Note App", style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // 使用 ListView.builder 來建立列表
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50), // 綠色背景
              borderRadius: BorderRadius.circular(25), // 圓角
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0), // 避免文字蓋到垃圾桶
                      child: Text(
                        notes[index].title,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 分隔線
                    Divider(color: Colors.black.withOpacity(0.2), thickness: 1),
                    const SizedBox(height: 10),
                    // 內容
                    Text(
                      notes[index].content,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                // 右上角的垃圾桶
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _deleteNote(index),
                    child: const Icon(Icons.delete, color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // 右下角的 + 號按鈕
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        backgroundColor: const Color(0xFFD1C4E9), // 淺紫色
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}

// 3. 新增筆記頁面
class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  // 控制輸入框的控制器
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    // 頁面銷毀時釋放資源
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Note", style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // 標題輸入框
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '12345', // 截圖中的範例提示字
                hintStyle: TextStyle(fontSize: 28, color: Colors.black26),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 28, color: Colors.black87),
            ),
            // 分隔線
            const Divider(thickness: 1),
            // 內容輸入框
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null, // 允許換行
                decoration: const InputDecoration(
                  hintText: 'Content',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.black26),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
      // 右下角的儲存按鈕
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 如果標題或內容是空的，也可以選擇不存，這裡直接存
          String title = _titleController.text;
          String content = _contentController.text;

          if (title.isEmpty) title = "No Title"; // 預設標題

          // 回傳一個新的 Note 物件給上一頁
          Navigator.pop(context, Note(title: title, content: content));
        },
        backgroundColor: const Color(0xFFD1C4E9), // 淺紫色
        child: const Icon(Icons.save, color: Colors.black87),
      ),
    );
  }
}