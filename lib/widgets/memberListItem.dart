import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.quantity, this.price, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("Confirm removal of $title from the cart"),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("No"),
                    ),
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text("Yes"),
                    )
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(fit: BoxFit.cover, child: Text("\$$price")),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              "Total: \$${price * quantity}",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
      onDismissed: (direction) {
        // final provider = Provider.of<Cart>(context,listen: false);
        // provider.removeItem(productId);
      },
    );
  }
}
