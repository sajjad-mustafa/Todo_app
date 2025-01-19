import 'package:flutter/material.dart';
import 'package:notes_app_in_sqflite/screens/db_handler.dart';
import 'package:notes_app_in_sqflite/screens/notes.dart';
import 'package:notes_app_in_sqflite/utils/device_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    loadData();

  }
  loadData() async {
    notesList = dbHelper!.getNotesList();
  }
  //function to show confirmation dialog
  Future<bool> showDeleteConfirmationDialog(BuildContext context)async{
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmatio',style: TextStyle(fontFamily: 'MyCustomFont',fontWeight: FontWeight.bold),),
        content: Text('Are you sure you want to delete this note',),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false),

              child: Text('Cancel'),
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Ok'))
        ],
      )
    )??
    false;
  }
  //Function to show the update dialog
  void showUpdateNoteModal(BuildContext context,NotesModel note){
    final _titleController = TextEditingController(text: note.title);
    final _ageController = TextEditingController(text: note.age.toString());
    final _descriptionController = TextEditingController(text: note.description);
    final _emailController = TextEditingController(text: note.email);
    showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text('Update Note'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight*0.025),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        hintText: 'title',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black,width: 5),
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                  SizedBox(height: screenHeight*0.015),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                        hintText: 'age',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black,width: 5),
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                  SizedBox(height:screenHeight*0.015),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'email',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black,width: 5),
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),

                  SizedBox(height: screenHeight*0.015),
                  TextFormField(
                    minLines: 2,
                    maxLines: 6,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        hintText: 'description',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black,width: 5),
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                  SizedBox(height: screenHeight*0.025),

                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: (){
                    if (_titleController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty){
                      dbHelper!.update(
                        NotesModel(
                          id: note.id,
                            age: int.parse(_ageController.text),
                            title: _titleController.text,
                            description: _descriptionController.text,
                            email: _emailController.text,
                        )
                      ).then((value){
                        setState(() {
                          notesList = dbHelper!.getNotesList();
                        });
                        Navigator.pop(context);
                      }).onError((error , stackTrace){
                        print(error.toString());
                      });

                    }
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
  //function to show bottom sheet and add data
  void showAddNoteModal(BuildContext context){
    final _titleController = TextEditingController();
    final _ageController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _emailController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context){
          return Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Notes',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,fontFamily: 'MyCustomFont'),),
                SizedBox(height: screenHeight*0.025),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'title',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,width: 5),
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                ),
                SizedBox(height: screenHeight*0.015),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                      hintText: 'age',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(height:screenHeight*0.015),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                      hintText: 'email',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),

                SizedBox(height: screenHeight*0.015),
                TextFormField(
                  minLines: 2,
                  maxLines: 6,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                      hintText: 'description',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(height: screenHeight*0.025),
                GestureDetector(
                  onTap: (){
                    if(_titleController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty
                    ){
                      dbHelper!.insert(
                        NotesModel(
                          age: int.parse(_ageController.text),
                          title: _titleController.text,
                          description: _descriptionController.text,
                          email: _emailController.text,
                        ),
                      ).then((value){
                        setState(() {
                          notesList = dbHelper!.getNotesList();
                        });
                        Navigator.pop(context);
                      }).onError((error, stackTrace){
                        print(error.toString());
                      });
                    }
                  },
                  child: Container(
                    width: screenWidth/2,
                    height: screenHeight*0.06,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text('Add Note',style: TextStyle(fontSize: screenWidth*0.05,fontWeight: FontWeight.bold,color: Colors.white),),),

                  ),
                )
              ],
            ),
          );
        });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Sql Notes App',style: TextStyle(fontFamily: 'MyCustomFont',fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: notesList,
                  builder: (context,AsyncSnapshot<List<NotesModel>>snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder:(context,index){
                            return Dismissible(
                              key:ValueKey<int>(snapshot.data![index].id!),
                             // direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.edit,color: Colors.white,),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete_forever,color: Colors.white,),
                              ),
                              confirmDismiss: (direction)async{
                                if(direction == DismissDirection.startToEnd){
                                  showUpdateNoteModal(context, snapshot.data![index]);
                                  return false;
                                }else if(direction == DismissDirection.endToStart){
                                  //Ask for Confirmation before deleting
                                  final confirmed =
                                  await showDeleteConfirmationDialog(context);
                                  if(confirmed){
                                    setState(() {
                                      dbHelper!.delete(snapshot.data![index].id!);
                                      notesList = dbHelper!.getNotesList();
                                      snapshot.data!.remove(snapshot.data![index]);
                                    });
                                    return true;
                                  }

                                  return false;
                                }
                                return false;

                              },

                              child: Card(
                                elevation: 0.10,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10),
                                  title: Text(snapshot.data![index].title.toString(),style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color:Colors.lightBlueAccent.shade400,fontFamily: 'MyCustomFont' ),),
                                  subtitle: Text(snapshot.data![index].description.toString(),style: TextStyle(fontSize: 20,color:Colors.black54,fontWeight: FontWeight.bold,fontFamily: 'MyCustomFont', ),),
                                  trailing: Text(snapshot.data![index].age.toString(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.purpleAccent),),
                                ),
                              ),
                            );

                          });
                    }else{
                      return CircularProgressIndicator();
                    }

                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed:(){
           showAddNoteModal(context);

          },
        child: Icon(Icons.add),
          ),
    );
  }
}
