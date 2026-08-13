import 'package:flutter/material.dart';
import 'package:tickets/core/models/ticket.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({super.key, required this.ticket});
  final Ticket ticket;

  final TextStyle subTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
  );

  final TextStyle mainTextStyle = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket: ${ticket.id}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListView(
            children: [
              SizedBox(
                height: 30,
                child: Text(ticket.displayName, textAlign: TextAlign.center),
              ),
              SizedBox(height: 30, child: Text('${ticket.date.day}')),
              Row(
                children: [
                  Expanded(child: Text('Items', style: subTextStyle)),
                  SizedBox(
                    width: 80,
                    height: 30,
                    child: Text(
                      'c/u',
                      textAlign: TextAlign.center,
                      style: subTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 80,
                    child: Text(
                      'Cant.',
                      textAlign: TextAlign.center,
                      style: subTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Total',
                      textAlign: TextAlign.end,
                      style: subTextStyle,
                    ),
                  ),
                ],
              ),
              ...ticket.items.map(
                (item) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.name)),
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: Text(
                        '${item.unitPrice}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '\$ ${item.subtotal}',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              if (ticket.discount != 0)
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Descuentos: ', style: subTextStyle),
                      Text('\$ ${ticket.discount}', style: subTextStyle),
                    ],
                  ),
                ),
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal:', style: subTextStyle),
                    Text('${ticket.total}', style: subTextStyle),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Balance anterior:', style: subTextStyle),
                    Text('${ticket.balanceBefore}', style: subTextStyle),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ', style: mainTextStyle),
                    Text('${ticket.balanceAfter}', style: mainTextStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
