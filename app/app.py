from flask import Flask, render_template, request, jsonify
from datetime import datetime
import json
import os

app = Flask(__name__)

# In-memory database for simplicity (use actual database in production)
books_db = [
    {
        "id": 1,
        "title": "The Great Gatsby",
        "author": "F. Scott Fitzgerald",
        "isbn": "978-0-7432-7356-5",
        "available": True,
        "rented_by": None,
        "rent_date": None,
        "return_date": None,
        "genre": "Classic Fiction",
        "description": "A classic American novel set in the Jazz Age."
    },
    {
        "id": 2,
        "title": "To Kill a Mockingbird",
        "author": "Harper Lee",
        "isbn": "978-0-06-112008-4",
        "available": True,
        "rented_by": None,
        "rent_date": None,
        "return_date": None,
        "genre": "Literary Fiction",
        "description": "A timeless story of moral courage in the American South."
    },
    {
        "id": 3,
        "title": "1984",
        "author": "George Orwell",
        "isbn": "978-0-452-28423-4",
        "available": False,
        "rented_by": "John Doe",
        "rent_date": "2024-01-15",
        "return_date": None,
        "genre": "Dystopian Fiction",
        "description": "A haunting vision of a totalitarian future."
    },
    {
        "id": 4,
        "title": "Pride and Prejudice",
        "author": "Jane Austen",
        "isbn": "978-0-14-143951-8",
        "available": True,
        "rented_by": None,
        "rent_date": None,
        "return_date": None,
        "genre": "Romance",
        "description": "A witty and romantic tale of love and social expectations."
    },
    {
        "id": 5,
        "title": "The Catcher in the Rye",
        "author": "J.D. Salinger",
        "isbn": "978-0-316-76948-0",
        "available": True,
        "rented_by": None,
        "rent_date": None,
        "return_date": None,
        "genre": "Coming of Age",
        "description": "A controversial and influential coming-of-age story."
    }
]

# Helper function to find book by ID
def find_book(book_id):
    return next((book for book in books_db if book["id"] == book_id), None)

# Helper function to get next ID
def get_next_id():
    return max(book["id"] for book in books_db) + 1 if books_db else 1

@app.route('/')
def index():
    """Render the main bookstore page"""
    return render_template('index.html')

@app.route('/api/books', methods=['GET'])
def get_books():
    """Get all books with optional filtering"""
    available_only = request.args.get('available', 'false').lower() == 'true'
    
    if available_only:
        filtered_books = [book for book in books_db if book["available"]]
        return jsonify({
            "status": "success",
            "data": filtered_books,
            "count": len(filtered_books)
        })
    
    return jsonify({
        "status": "success",
        "data": books_db,
        "count": len(books_db)
    })

@app.route('/api/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    """Get a specific book by ID"""
    book = find_book(book_id)
    if not book:
        return jsonify({
            "status": "error",
            "message": "Book not found"
        }), 404
    
    return jsonify({
        "status": "success",
        "data": book
    })

@app.route('/api/books', methods=['POST'])
def add_book():
    """Add a new book to the collection"""
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['title', 'author', 'isbn']
        for field in required_fields:
            if field not in data or not data[field].strip():
                return jsonify({
                    "status": "error",
                    "message": f"Missing required field: {field}"
                }), 400
        
        # Create new book
        new_book = {
            "id": get_next_id(),
            "title": data['title'].strip(),
            "author": data['author'].strip(),
            "isbn": data['isbn'].strip(),
            "available": True,
            "rented_by": None,
            "rent_date": None,
            "return_date": None,
            "genre": data.get('genre', 'General').strip(),
            "description": data.get('description', '').strip()
        }
        
        books_db.append(new_book)
        
        return jsonify({
            "status": "success",
            "message": "Book added successfully",
            "data": new_book
        }), 201
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": "Invalid JSON data"
        }), 400

@app.route('/api/books/<int:book_id>/rent', methods=['PUT'])
def rent_book(book_id):
    """Rent a book"""
    try:
        data = request.get_json()
        book = find_book(book_id)
        
        if not book:
            return jsonify({
                "status": "error",
                "message": "Book not found"
            }), 404
        
        if not book["available"]:
            return jsonify({
                "status": "error",
                "message": f"Book is already rented by {book['rented_by']}"
            }), 400
        
        # Validate renter name
        renter_name = data.get('rented_by', '').strip()
        if not renter_name:
            return jsonify({
                "status": "error",
                "message": "Renter name is required"
            }), 400
        
        # Update book status
        book["available"] = False
        book["rented_by"] = renter_name
        book["rent_date"] = datetime.now().strftime("%Y-%m-%d")
        book["return_date"] = None
        
        return jsonify({
            "status": "success",
            "message": f"Book '{book['title']}' rented successfully to {renter_name}",
            "data": book
        })
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": "Invalid request data"
        }), 400

@app.route('/api/books/<int:book_id>/return', methods=['PUT'])
def return_book(book_id):
    """Return a rented book"""
    book = find_book(book_id)
    
    if not book:
        return jsonify({
            "status": "error",
            "message": "Book not found"
        }), 404
    
    if book["available"]:
        return jsonify({
            "status": "error",
            "message": "Book is not currently rented"
        }), 400
    
    # Update book status
    returned_by = book["rented_by"]
    book["available"] = True
    book["return_date"] = datetime.now().strftime("%Y-%m-%d")
    book["rented_by"] = None
    
    return jsonify({
        "status": "success",
        "message": f"Book '{book['title']}' returned successfully by {returned_by}",
        "data": book
    })

@app.route('/api/books/<int:book_id>', methods=['DELETE'])
def delete_book(book_id):
    """Delete a book from the collection"""
    book = find_book(book_id)
    
    if not book:
        return jsonify({
            "status": "error",
            "message": "Book not found"
        }), 404
    
    books_db.remove(book)
    
    return jsonify({
        "status": "success",
        "message": f"Book '{book['title']}' deleted successfully"
    })

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Get bookstore statistics"""
    total_books = len(books_db)
    available_books = len([book for book in books_db if book["available"]])
    rented_books = total_books - available_books
    
    genres = {}
    for book in books_db:
        genre = book.get("genre", "General")
        genres[genre] = genres.get(genre, 0) + 1
    
    return jsonify({
        "status": "success",
        "data": {
            "total_books": total_books,
            "available_books": available_books,
            "rented_books": rented_books,
            "genres": genres
        }
    })

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        "status": "error",
        "message": "Endpoint not found"
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        "status": "error",
        "message": "Internal server error"
    }), 500

if __name__ == '__main__':
    # Create logs directory if it doesn't exist
    if not os.path.exists('logs'):
        os.makedirs('logs')
    
    # Run the app
    app.run(host='0.0.0.0', port=8080, debug=False)