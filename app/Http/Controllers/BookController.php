<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Book;
use App\Models\Genre;
use App\Models\Cart;
use App\Models\Userbooks;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

use Session;
use Stripe;

class BookController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request, $id)
    {
        $books=Book::where('genre_id','=',$id)->get();

        $genre = Genre::findOrFail($id);
        return view('books',['genre_id'=>$id,'books'=>$books], compact('genre'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create($id)
    {
        $genre = Genre::findOrFail($id);
        if(Auth::check()){

        return view('book_new', compact('genre'));
        }
        return redirect('book/genre/' . $genre->id)->withErrors(['msg' => 'This option is for authentificated users only!']);
    }


    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $book = new Book();
        $book->name = $request->name;
        $book->author_name = $request->author_name;
        $book->description  = $request->description;
        $book->price  = $request->price;
        $book->genre_id = $request->genre_id;
        $book->save();
        return redirect('book/genre/' . $book->genre_id);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        if(Auth::check() && auth()->user()->role=='admin'){
        $book = Book::where('id','=',$id)->first();
        return view('edit_book', compact('book'));

        }
        return redirect()->back()->withErrors(['msg' => 'This option is for admins only!']);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $book = Book::where('id','=',$id)->first();
        $book->name = $request->name;
        $book->author_name = $request->author_name;
        $book->description  = $request->description;
        $book->price  = $request->price;
        $book->genre_id = $request->genre_id;
        $book->save();
        return redirect('book/genre/' . $book->genre_id);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $genre_id = Book::findOrFail($id)->genre_id;
        if(Auth::check() && auth()->user()->role=='admin'){
        Book::findOrFail($id)->delete();
        return redirect('book/genre/' . $genre_id);}
        return redirect('book/genre/' . $genre_id)->withErrors(['msg' => 'This option is for admins only!']);
    }
    public function add_cart($id)
    {
        $book=Book::findOrFail($id);
        $genre_id = Book::findOrFail($id)->genre_id;
        if(Auth::check()){

            $user = Auth::user();

            $cart = new cart;

            $cart->name = $user->name;

            $cart->email = $user->email;

            $cart->book_title = $book->name;

            $cart->price = $book->price;

            $cart->user_id = Auth::user()->id;

            $cart->book_id = $book->id;

            $cart->save();
            return redirect()->back();
        }
        return redirect('/login');
    }
    public function show_cart(){

        if(Auth::check()){
            $id=Auth::user()->id;

            $cart = cart::where('user_id','=',$id)->get();

            return view('showcart', compact('cart'));
        }
        return redirect('login');
    }
    public function remove_cart($id){
        $cart=cart::find($id);

        $cart->delete();

        return redirect()->back();
    }
    
}
