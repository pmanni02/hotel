1. What classes does each implementation include? Are the lists the same?
  Each implementation has a CartEntry, ShoppingCart, and Order class.

2. Write down a sentence to describe each class.
  The CartEntry class is responsible for the individual item(s) inside the shopping cart.

  The ShoppingCart class is responsible for all of the items in the shopping cart (instances of CartEntry).

  The Order class is responsible for one instance of a shopping trip (shopping cart).

3. How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
  The Order class contains one instance of the ShoppingCart class. The ShoppingCart class contains an array of CartEntry class instances.

4. What data does each class store? How (if at all) does this differ between the two implementations?
  For both implementations, the CartEntry class contains the unit price and quantity of a cart item. The ShoppingCart class contains an array of CartEntry instances. The Order class contains an instance of the ShoppingCart class and a Sales_Tax constant variable.

5. What methods does each class have? How (if at all) does this differ between the two implementations?
  All of the classes have initialize methods. In implementation A, the Order class has a total_price method. In implementation B, all three classes have price methods.

6. Consider the Order#total_price method. In each implementation:
  a. Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
    In implementation A, the logic to compute price is retained in the Order class. In implementation B, the logic to compute price is delegated to lower level classes.

  b. Does total_price directly manipulate the instance variables of other classes?
    In implementation A, the total_price method does manipulate instance variables of other classes. In implementation B, the total_price method does not directly manipulate instance variables. The instance variables of other classes are manipulated through class methods.

7. If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
  In order to implement this change, a new method would have to be added to the CartEntry class to contain the logic for changing the price based on quantity. It would be easier to change implementation B because it already contains a price method.

8. Which implementation better adheres to the single responsibility principle?
  Implementation B better adheres to the single responsibility principle because the logic of calculating the total cost is passed off to "lower level" classes. The Order class, in implementation B, calls the methods of other classes instead of directly manipulating instance variables.

9. Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
  Implementation B is more loosely coupled because each of the classes have less dependency. In implementation A, the data in the CartEntry and ShoppingCart classes are not useful without the Order class. But in implementation B, the CartEntry and ShoppingCart classes do not necessarily need the Order class. They are still dependent on each other but not as dependent as in implementation A.
